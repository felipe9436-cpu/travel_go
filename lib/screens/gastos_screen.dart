
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GastosScreen extends StatefulWidget {
  const GastosScreen({super.key});

  @override
  State<GastosScreen> createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> {
  double _orcamento = 0;

  final List<_Gasto> _gastos = [];

  final List<String> _categorias = [
    'Todos',
    'Alimentação',
    'Transporte',
    'Hospedagem',
    'Passeio',
    'Compras',
    'Outros',
  ];

  String _categoriaSelecionada = 'Todos';
  String _ordenacao = 'recente';

  double get _totalGastos =>
      _gastos.fold(0, (total, gasto) => total + gasto.valor);

  double get _restante => _orcamento - _totalGastos;

  double get _porcentagemOrcamento {
    if (_orcamento <= 0) return 0;
    return (_totalGastos / _orcamento).clamp(0.0, 1.0);
  }

  List<_Gasto> get _gastosFiltrados {
    final lista = _gastos.where((gasto) {
      return _categoriaSelecionada == 'Todos' ||
          gasto.categoria == _categoriaSelecionada;
    }).toList();

    switch (_ordenacao) {
      case 'maior':
        lista.sort((a, b) => b.valor.compareTo(a.valor));
        break;
      case 'menor':
        lista.sort((a, b) => a.valor.compareTo(b.valor));
        break;
      case 'recente':
        lista.sort((a, b) => b.data.compareTo(a.data));
        break;
    }

    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos'),
        actions: [
          IconButton(
            tooltip: 'Configurar orçamento',
            onPressed: _editarOrcamento,
            icon: const Icon(Icons.account_balance_wallet_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 800;

          return ListView(
            padding: EdgeInsets.fromLTRB(
              isWide ? 32 : 20,
              12,
              isWide ? 32 : 20,
              110,
            ),
            children: [
              Text(
                'Controle financeiro',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Acompanhe as despesas e mantenha sua viagem dentro do orçamento.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              _buildResumo(),
              const SizedBox(height: 28),
              _buildCategorias(),
              const SizedBox(height: 28),
              _buildListaHeader(),
              const SizedBox(height: 14),
              _buildListaGastos(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarGasto,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar gasto'),
      ),
    );
  }

  Widget _buildResumo() {
    final ultrapassou = _orcamento > 0 && _totalGastos > _orcamento;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total de despesas',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Editar orçamento',
                  onPressed: _editarOrcamento,
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _moeda(_totalGastos),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: _IndicadorFinanceiro(
                    titulo: 'Orçamento',
                    valor: _moeda(_orcamento),
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _IndicadorFinanceiro(
                    titulo: ultrapassou ? 'Acima do limite' : 'Disponível',
                    valor: _moeda(_restante),
                    icon: ultrapassou
                        ? Icons.warning_amber_outlined
                        : Icons.savings_outlined,
                    cor: ultrapassou ? AppColors.error : AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: _porcentagemOrcamento,
                minHeight: 8,
                backgroundColor: AppColors.border,
                color: ultrapassou ? AppColors.error : AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _orcamento <= 0
                  ? 'Defina um orçamento para acompanhar seu progresso.'
                  : '${(_totalGastos / _orcamento * 100).toStringAsFixed(0)}% do orçamento utilizado',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorias() {
    final categorias = [
      ('Alimentação', Icons.restaurant_outlined),
      ('Transporte', Icons.directions_car_outlined),
      ('Hospedagem', Icons.hotel_outlined),
      ('Passeio', Icons.local_activity_outlined),
      ('Compras', Icons.shopping_bag_outlined),
      ('Outros', Icons.receipt_long_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Por categoria',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final colunas = constraints.maxWidth >= 700 ? 3 : 2;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categorias.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: colunas,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 94,
              ),
              itemBuilder: (context, index) {
                final categoria = categorias[index].$1;
                final icon = categorias[index].$2;
                final selecionada = _categoriaSelecionada == categoria;

                return Card(
                  color: selecionada
                      ? AppColors.surfaceElevated
                      : AppColors.surface,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        _categoriaSelecionada =
                        selecionada ? 'Todos' : categoria;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(icon, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  categoria,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _moeda(_totalCategoria(categoria)),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildListaHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _categoriaSelecionada == 'Todos'
                    ? 'Seus gastos'
                    : _categoriaSelecionada,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '${_gastosFiltrados.length} despesa(s) registrada(s)',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'Ordenar gastos',
          initialValue: _ordenacao,
          onSelected: (valor) {
            setState(() => _ordenacao = valor);
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'recente', child: Text('Mais recentes')),
            PopupMenuItem(value: 'maior', child: Text('Maior valor')),
            PopupMenuItem(value: 'menor', child: Text('Menor valor')),
          ],
          icon: const Icon(Icons.sort),
        ),
      ],
    );
  }

  Widget _buildListaGastos() {
    final gastos = _gastosFiltrados;

    if (gastos.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 44,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: 14),
              Text(
                _gastos.isEmpty
                    ? 'Nenhum gasto registrado'
                    : 'Nenhum gasto nesta categoria',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Adicione uma despesa para começar a acompanhar os custos da viagem.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _adicionarGasto,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar primeiro gasto'),
              ),
              if (_categoriaSelecionada != 'Todos') ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    setState(() => _categoriaSelecionada = 'Todos');
                  },
                  child: const Text('Limpar filtro'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final gasto in gastos)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _GastoCard(
              gasto: gasto,
              onTap: () => _mostrarDetalhes(gasto),
              onDelete: () => _removerGasto(gasto),
            ),
          ),
      ],
    );
  }

  void _adicionarGasto() {
    final descricaoController = TextEditingController();
    final valorController = TextEditingController();
    String categoria = 'Alimentação';
    DateTime data = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                22,
                8,
                22,
                MediaQuery.viewInsetsOf(context).bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adicionar gasto',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: descricaoController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        hintText: 'Ex.: Almoço',
                        prefixIcon: Icon(Icons.receipt_long_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: valorController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Valor',
                        prefixText: 'R\$ ',
                        hintText: '0,00',
                        prefixIcon: Icon(Icons.payments_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Categoria',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final item in _categorias.skip(1))
                          ChoiceChip(
                            label: Text(item),
                            selected: categoria == item,
                            onSelected: (_) {
                              setModalState(() => categoria = item);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final selecionada = await showDatePicker(
                          context: context,
                          initialDate: data,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (selecionada != null) {
                          setModalState(() => data = selecionada);
                        }
                      },
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text('Data: ${_dataFormatada(data)}'),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          final descricao = descricaoController.text.trim();
                          final valor = _converterValor(valorController.text);

                          if (descricao.isEmpty || valor <= 0) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Informe uma descrição e um valor maior que zero.',
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _gastos.add(
                              _Gasto(
                                descricao: descricao,
                                categoria: categoria,
                                valor: valor,
                                data: data,
                              ),
                            );
                          });

                          Navigator.pop(sheetContext);
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Gasto adicionado com sucesso.'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Salvar gasto'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      descricaoController.dispose();
      valorController.dispose();
    });
  }

  void _editarOrcamento() {
    final controller = TextEditingController(
      text: _orcamento.toStringAsFixed(2).replaceAll('.', ','),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Orçamento da viagem'),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Valor planejado',
              prefixText: 'R\$ ',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final valor = _converterValor(controller.text);

                if (valor <= 0) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text('Informe um orçamento maior que zero.'),
                    ),
                  );
                  return;
                }

                setState(() => _orcamento = valor);
                Navigator.pop(dialogContext);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    ).whenComplete(controller.dispose);
  }

  void _mostrarDetalhes(_Gasto gasto) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gasto.descricao,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  gasto.categoria,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                _LinhaDetalhe(
                  titulo: 'Valor',
                  valor: _moeda(gasto.valor),
                  icon: Icons.payments_outlined,
                ),
                const SizedBox(height: 14),
                _LinhaDetalhe(
                  titulo: 'Data',
                  valor: _dataFormatada(gasto.data),
                  icon: Icons.calendar_today_outlined,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _removerGasto(gasto);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Excluir gasto'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removerGasto(_Gasto gasto) {
    final index = _gastos.indexOf(gasto);
    if (index < 0) return;

    setState(() => _gastos.removeAt(index));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${gasto.descricao} removido.'),
        action: SnackBarAction(
          label: 'DESFAZER',
          onPressed: () {
            if (!mounted) return;
            setState(() {
              _gastos.insert(index.clamp(0, _gastos.length), gasto);
            });
          },
        ),
      ),
    );
  }

  double _totalCategoria(String categoria) {
    return _gastos
        .where((gasto) => gasto.categoria == categoria)
        .fold(0, (total, gasto) => total + gasto.valor);
  }

  double _converterValor(String texto) {
    var valor = texto.trim().replaceAll('R\$', '').replaceAll(' ', '');

    if (valor.contains(',') && valor.contains('.')) {
      valor = valor.replaceAll('.', '').replaceAll(',', '.');
    } else if (valor.contains(',')) {
      valor = valor.replaceAll(',', '.');
    }

    return double.tryParse(valor) ?? 0;
  }

  String _moeda(double valor) {
    final partes = valor.toStringAsFixed(2).split('.');
    final inteiro = partes[0];
    final buffer = StringBuffer();

    for (var i = 0; i < inteiro.length; i++) {
      buffer.write(inteiro[i]);
      final restantes = inteiro.length - i - 1;
      if (restantes > 0 && restantes % 3 == 0) {
        buffer.write('.');
      }
    }

    return 'R\$ ${buffer.toString()},${partes[1]}';
  }

  String _dataFormatada(DateTime data) {
    const meses = [
      'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
      'jul', 'ago', 'set', 'out', 'nov', 'dez',
    ];

    return '${data.day} ${meses[data.month - 1]} ${data.year}';
  }
}

class _Gasto {
  final String descricao;
  final String categoria;
  final double valor;
  final DateTime data;

  const _Gasto({
    required this.descricao,
    required this.categoria,
    required this.valor,
    required this.data,
  });
}

class _IndicadorFinanceiro extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icon;
  final Color? cor;

  const _IndicadorFinanceiro({
    required this.titulo,
    required this.valor,
    required this.icon,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: cor ?? AppColors.primary),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GastoCard extends StatelessWidget {
  final _Gasto gasto;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _GastoCard({
    required this.gasto,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(gasto),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          onTap: onTap,
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _iconeCategoria(gasto.categoria),
              color: _corCategoria(gasto.categoria),
            ),
          ),
          title: Text(
            gasto.descricao,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            '${gasto.categoria} • ${_dataCurta(gasto.data)}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatar(gasto.valor),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _iconeCategoria(String categoria) {
    switch (categoria) {
      case 'Alimentação':
        return Icons.restaurant_outlined;
      case 'Transporte':
        return Icons.directions_car_outlined;
      case 'Hospedagem':
        return Icons.hotel_outlined;
      case 'Passeio':
        return Icons.local_activity_outlined;
      case 'Compras':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  static Color _corCategoria(String categoria) {
    switch (categoria) {
      case 'Alimentação':
        return AppColors.success;
      case 'Transporte':
        return AppColors.cyan;
      case 'Hospedagem':
        return AppColors.blue;
      case 'Passeio':
        return AppColors.primary;
      case 'Compras':
        return const Color(0xFF8B5CF6);
      default:
        return AppColors.textSecondary;
    }
  }

  static String _formatar(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  static String _dataCurta(DateTime data) {
    return '${data.day}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}

class _LinhaDetalhe extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icon;

  const _LinhaDetalhe({
    required this.titulo,
    required this.valor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Text(
          valor,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
