import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GastosScreen extends StatefulWidget {
  const GastosScreen({super.key});

  @override
  State<GastosScreen> createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> {
  double _orcamento = 6000;

  final List<_Gasto> _gastos = [
    const _Gasto(
      descricao: 'Hotel Le Central',
      categoria: 'Hospedagem',
      valor: 3240,
      data: '12 Dez',
      icon: Icons.hotel_outlined,
      cor: AppColors.blue,
    ),
    const _Gasto(
      descricao: 'Jantar',
      categoria: 'Alimentação',
      valor: 185,
      data: '12 Dez',
      icon: Icons.restaurant_outlined,
      cor: AppColors.success,
    ),
    const _Gasto(
      descricao: 'Ingresso Louvre',
      categoria: 'Passeio',
      valor: 120,
      data: '13 Dez',
      icon: Icons.museum_outlined,
      cor: AppColors.primary,
    ),
    const _Gasto(
      descricao: 'Uber',
      categoria: 'Transporte',
      valor: 75,
      data: '13 Dez',
      icon: Icons.directions_car_outlined,
      cor: Color(0xFF8B5CF6),
    ),
    const _Gasto(
      descricao: 'Café da manhã',
      categoria: 'Alimentação',
      valor: 42,
      data: '14 Dez',
      icon: Icons.local_cafe_outlined,
      cor: AppColors.warning,
    ),
  ];

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

  double get _totalGastos {
    return _gastos.fold(
      0,
          (total, gasto) => total + gasto.valor,
    );
  }

  double get _restante {
    final valor = _orcamento - _totalGastos;
    return valor < 0 ? 0 : valor;
  }

  double get _porcentagemOrcamento {
    if (_orcamento <= 0) return 0;

    final porcentagem = _totalGastos / _orcamento;

    return porcentagem > 1 ? 1 : porcentagem;
  }

  List<_Gasto> get _gastosFiltrados {
    if (_categoriaSelecionada == 'Todos') {
      return _gastos;
    }

    return _gastos
        .where(
          (gasto) => gasto.categoria == _categoriaSelecionada,
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              title: const Text(
                'Gastos',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              actions: [
                IconButton.filledTonal(
                  tooltip: 'Configurar orçamento',
                  onPressed: _editarOrcamento,
                  icon: const Icon(
                    Icons.settings_outlined,
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                110,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildFinancialOverview(),
                  const SizedBox(height: 24),
                  _buildCategoryOverview(),
                  const SizedBox(height: 28),
                  _buildFilterSection(),
                  const SizedBox(height: 18),
                  _buildExpenseHeader(),
                ]),
              ),
            ),
            _buildExpenseList(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                28,
                20,
                100,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildFinancialTip(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirAdicionarGasto,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar gasto'),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Controle financeiro',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 7),
        const Text(
          'Acompanhe o orçamento da viagem e saiba exatamente onde seu dinheiro está indo.',
          style: TextStyle(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialOverview() {
    final ultrapassouOrcamento = _totalGastos > _orcamento;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(
                      alpha: 0.12,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.success,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total da viagem',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Despesas acumuladas',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Editar orçamento',
                  onPressed: _editarOrcamento,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 19,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              _formatarMoeda(_totalGastos),
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'de ${_formatarMoeda(_orcamento)} de orçamento',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: _porcentagemOrcamento,
                minHeight: 9,
                backgroundColor: AppColors.border,
                color: ultrapassouOrcamento
                    ? AppColors.error
                    : AppColors.primary,
              ),
            ),
            const SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(_porcentagemOrcamento * 100).toStringAsFixed(0)}% utilizado',
                  style: TextStyle(
                    color: ultrapassouOrcamento
                        ? AppColors.error
                        : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  ultrapassouOrcamento
                      ? 'Orçamento ultrapassado'
                      : '${_formatarMoeda(_restante)} restantes',
                  style: TextStyle(
                    color: ultrapassouOrcamento
                        ? AppColors.error
                        : AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryOverview() {
    final categorias = [
      _CategoriaGasto(
        nome: 'Hospedagem',
        valor: _totalPorCategoria('Hospedagem'),
        icon: Icons.hotel_outlined,
        cor: AppColors.blue,
      ),
      _CategoriaGasto(
        nome: 'Alimentação',
        valor: _totalPorCategoria('Alimentação'),
        icon: Icons.restaurant_outlined,
        cor: AppColors.success,
      ),
      _CategoriaGasto(
        nome: 'Passeio',
        valor: _totalPorCategoria('Passeio'),
        icon: Icons.local_activity_outlined,
        cor: AppColors.primary,
      ),
      _CategoriaGasto(
        nome: 'Transporte',
        valor: _totalPorCategoria('Transporte'),
        icon: Icons.directions_car_outlined,
        cor: const Color(0xFF8B5CF6),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Por categoria',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 112,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categorias.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return _CategoryCard(
                categoria: categorias[index],
                onTap: () {
                  setState(() {
                    _categoriaSelecionada =
                        categorias[index].nome;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return SizedBox(
      height: 43,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categorias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final categoria = _categorias[index];

          return ChoiceChip(
            label: Text(categoria),
            selected: _categoriaSelecionada == categoria,
            showCheckmark: false,
            onSelected: (_) {
              setState(() {
                _categoriaSelecionada = categoria;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildExpenseHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Últimos gastos',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Suas despesas registradas',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'Ordenar',
          onSelected: _ordenarGastos,
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'maior',
              child: Text('Maior valor'),
            ),
            PopupMenuItem(
              value: 'menor',
              child: Text('Menor valor'),
            ),
            PopupMenuItem(
              value: 'recente',
              child: Text('Mais recentes'),
            ),
          ],
          icon: const Icon(Icons.sort),
        ),
      ],
    );
  }

  Widget _buildExpenseList() {
    final gastos = _gastosFiltrados;

    if (gastos.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverToBoxAdapter(
          child: _buildEmptyState(),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final gasto = gastos[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ExpenseCard(
                gasto: gasto,
                onTap: () => _abrirDetalhes(gasto),
                onDelete: () => _removerGasto(gasto),
              ),
            );
          },
          childCount: gastos.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              color: AppColors.textMuted,
              size: 48,
            ),
            const SizedBox(height: 15),
            const Text(
              'Nenhum gasto encontrado',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Não existem gastos nessa categoria.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _categoriaSelecionada = 'Todos';
                });
              },
              child: const Text('Ver todos'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialTip() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(21),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(
                  alpha: 0.12,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dica financeira',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Defina um orçamento antes da viagem e acompanhe os gastos por categoria para evitar surpresas.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirAdicionarGasto() {
    final descricaoController = TextEditingController();
    final valorController = TextEditingController();

    String categoriaSelecionada = 'Alimentação';
    DateTime dataSelecionada = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                8,
                24,
                MediaQuery.viewInsetsOf(context).bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Novo gasto',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Registre uma nova despesa da viagem.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: descricaoController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        hintText: 'Ex.: Jantar em Paris',
                        prefixIcon: Icon(
                          Icons.receipt_long_outlined,
                        ),
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
                        hintText: 'Ex.: 150,00',
                        prefixIcon: Icon(
                          Icons.payments_outlined,
                        ),
                        prefixText: 'R\$ ',
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Categoria',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final categoria in [
                          'Alimentação',
                          'Transporte',
                          'Hospedagem',
                          'Passeio',
                          'Compras',
                          'Outros',
                        ])
                          ChoiceChip(
                            label: Text(categoria),
                            selected:
                            categoriaSelecionada == categoria,
                            onSelected: (_) {
                              setModalState(() {
                                categoriaSelecionada =
                                    categoria;
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final data = await showDatePicker(
                          context: context,
                          initialDate: dataSelecionada,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );

                        if (data != null) {
                          setModalState(() {
                            dataSelecionada = data;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                      ),
                      label: Text(
                        'Data: ${_formatarData(dataSelecionada)}',
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          final valor = _converterValor(
                            valorController.text,
                          );

                          if (descricaoController.text
                              .trim()
                              .isEmpty ||
                              valor <= 0) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Preencha a descrição e informe um valor válido.',
                                ),
                              ),
                            );
                            return;
                          }

                          final novoGasto = _Gasto(
                            descricao:
                            descricaoController.text.trim(),
                            categoria: categoriaSelecionada,
                            valor: valor,
                            data: _formatarData(dataSelecionada),
                            icon: _iconeCategoria(
                              categoriaSelecionada,
                            ),
                            cor: _corCategoria(
                              categoriaSelecionada,
                            ),
                          );

                          setState(() {
                            _gastos.insert(0, novoGasto);
                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(this.context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Gasto adicionado com sucesso.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar gasto'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _editarOrcamento() {
    final controller = TextEditingController(
      text: _orcamento.toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Orçamento da viagem'),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Valor do orçamento',
              prefixText: 'R\$ ',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final valor = _converterValor(controller.text);

                if (valor <= 0) {
                  return;
                }

                setState(() {
                  _orcamento = valor;
                });

                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _abrirDetalhes(_Gasto gasto) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              8,
              24,
              30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: gasto.cor.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Icon(
                        gasto.icon,
                        color: gasto.cor,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            gasto.descricao,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            gasto.categoria,
                            style: TextStyle(
                              color: gasto.cor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _DetailRow(
                  icon: Icons.payments_outlined,
                  title: 'Valor',
                  value: _formatarMoeda(gasto.valor),
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  title: 'Data',
                  value: gasto.data,
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.category_outlined,
                  title: 'Categoria',
                  value: gasto.categoria,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _removerGasto(gasto);
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
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

    if (index == -1) return;

    setState(() {
      _gastos.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${gasto.descricao} removido.',
        ),
        action: SnackBarAction(
          label: 'DESFAZER',
          onPressed: () {
            setState(() {
              _gastos.insert(index, gasto);
            });
          },
        ),
      ),
    );
  }

  void _ordenarGastos(String tipo) {
    setState(() {
      switch (tipo) {
        case 'maior':
          _gastos.sort(
                (a, b) => b.valor.compareTo(a.valor),
          );
          break;
        case 'menor':
          _gastos.sort(
                (a, b) => a.valor.compareTo(b.valor),
          );
          break;
        case 'recente':
        // Os gastos adicionados ficam no início da lista.
          break;
      }
    });
  }

  double _totalPorCategoria(String categoria) {
    return _gastos
        .where((gasto) => gasto.categoria == categoria)
        .fold(
      0,
          (total, gasto) => total + gasto.valor,
    );
  }

  IconData _iconeCategoria(String categoria) {
    switch (categoria) {
      case 'Hospedagem':
        return Icons.hotel_outlined;
      case 'Alimentação':
        return Icons.restaurant_outlined;
      case 'Passeio':
        return Icons.local_activity_outlined;
      case 'Transporte':
        return Icons.directions_car_outlined;
      case 'Compras':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  Color _corCategoria(String categoria) {
    switch (categoria) {
      case 'Hospedagem':
        return AppColors.blue;
      case 'Alimentação':
        return AppColors.success;
      case 'Passeio':
        return AppColors.primary;
      case 'Transporte':
        return const Color(0xFF8B5CF6);
      case 'Compras':
        return AppColors.cyan;
      default:
        return AppColors.textSecondary;
    }
  }

  double _converterValor(String texto) {
    var valor = texto.trim();

    if (valor.isEmpty) return 0;

    valor = valor.replaceAll('R\$', '').trim();

    if (valor.contains(',') && valor.contains('.')) {
      valor = valor.replaceAll('.', '').replaceAll(',', '.');
    } else if (valor.contains(',')) {
      valor = valor.replaceAll(',', '.');
    }

    return double.tryParse(valor) ?? 0;
  }

  String _formatarMoeda(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String _formatarData(DateTime data) {
    const meses = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];

    return '${data.day} ${meses[data.month - 1]}';
  }
}

class _Gasto {
  final String descricao;
  final String categoria;
  final double valor;
  final String data;
  final IconData icon;
  final Color cor;

  const _Gasto({
    required this.descricao,
    required this.categoria,
    required this.valor,
    required this.data,
    required this.icon,
    required this.cor,
  });
}

class _CategoriaGasto {
  final String nome;
  final double valor;
  final IconData icon;
  final Color cor;

  const _CategoriaGasto({
    required this.nome,
    required this.valor,
    required this.icon,
    required this.cor,
  });
}

class _CategoryCard extends StatelessWidget {
  final _CategoriaGasto categoria;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.categoria,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      categoria.icon,
                      color: categoria.cor,
                      size: 19,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textMuted,
                      size: 18,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  categoria.nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'R\$ ${categoria.valor.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final _Gasto gasto;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ExpenseCard({
    required this.gasto,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(
        '${gasto.descricao}_${gasto.data}_${gasto.valor}',
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      background: Container(
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: gasto.cor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    gasto.icon,
                    color: gasto.cor,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        gasto.descricao,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            gasto.categoria,
                            style: TextStyle(
                              color: gasto.cor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                            ),
                            child: Text(
                              '•',
                              style: TextStyle(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                          Text(
                            gasto.data,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ${gasto.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textMuted,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}