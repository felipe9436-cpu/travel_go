
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final List<_ChecklistItem> _itens = [];

  final List<String> _categorias = [
    'Todos',
    'Documentos',
    'Reservas',
    'Mala',
    'Compras',
    'Viagem',
  ];

  String _categoriaSelecionada = 'Todos';

  int get _concluidos =>
      _itens.where((item) => item.concluido).length;

  int get _totalItens => _itens.length;

  double get _progresso =>
      _totalItens == 0 ? 0 : _concluidos / _totalItens;

  List<_ChecklistItem> get _itensFiltrados {
    if (_categoriaSelecionada == 'Todos') {
      return _itens;
    }

    return _itens
        .where((item) => item.categoria == _categoriaSelecionada)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final itens = _itensFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checklist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Opções',
            onPressed: _abrirOpcoes,
            icon: const Icon(Icons.more_vert),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        children: [
          Text(
            'Organize sua viagem',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Adicione as tarefas e confira o que ainda falta fazer.',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          _buildProgressCard(),

          const SizedBox(height: 28),

          const Text(
            'Categorias',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 42,
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
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Itens da viagem',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '$_concluidos/$_totalItens',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            'Toque em um item para ver os detalhes.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 14),

          if (itens.isEmpty)
            _buildEmptyState()
          else
            ...itens.map(
                  (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ChecklistCard(
                  item: item,
                  onToggle: () => _alternarItem(item),
                  onDelete: () => _removerItem(item),
                  onTap: () => _abrirDetalhes(item),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarItem,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar item'),
      ),
    );
  }

  Widget _buildProgressCard() {
    final completo = _totalItens > 0 && _concluidos == _totalItens;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                completo
                    ? Icons.check_circle_outline
                    : Icons.checklist_outlined,
                color: completo ? AppColors.success : AppColors.primary,
                size: 30,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      completo
                          ? 'Tudo pronto!'
                          : 'Progresso da viagem',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_concluidos de $_totalItens concluídos',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(_progresso * 100).round()}%',
                style: TextStyle(
                  color: completo ? AppColors.success : AppColors.primary,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progresso,
              minHeight: 7,
              backgroundColor: AppColors.border,
              color: completo ? AppColors.success : AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_concluidos concluídos',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                '${_totalItens - _concluidos} restantes',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.checklist_outlined,
            size: 42,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 14),
          Text(
            _itens.isEmpty
                ? 'Seu checklist está vazio'
                : 'Nenhum item encontrado',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _itens.isEmpty
                ? 'Adicione tarefas para organizar sua próxima viagem.'
                : 'Não existem itens nesta categoria.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _itens.isEmpty
                ? _adicionarItem
                : () {
              setState(() {
                _categoriaSelecionada = 'Todos';
              });
            },
            icon: Icon(
              _itens.isEmpty ? Icons.add : Icons.list,
            ),
            label: Text(
              _itens.isEmpty ? 'Criar primeiro item' : 'Ver todos',
            ),
          ),
        ],
      ),
    );
  }

  void _alternarItem(_ChecklistItem item) {
    setState(() {
      item.concluido = !item.concluido;
    });

    if (item.concluido && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.titulo} concluído!'),
          duration: const Duration(milliseconds: 1300),
        ),
      );
    }
  }

  Future<void> _adicionarItem() async {
    final controller = TextEditingController();
    String categoria = 'Viagem';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                MediaQuery.viewInsetsOf(context).bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Novo item',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Adicione algo que precisa fazer ou levar.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Nome do item',
                        hintText: 'Ex.: Separar documentos',
                        prefixIcon: Icon(Icons.checklist_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Categoria',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final itemCategoria in _categorias.skip(1))
                          ChoiceChip(
                            label: Text(itemCategoria),
                            selected: categoria == itemCategoria,
                            onSelected: (_) {
                              setModalState(() {
                                categoria = itemCategoria;
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          final nome = controller.text.trim();

                          if (nome.isEmpty) {
                            ScaffoldMessenger.of(sheetContext)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Digite o nome do item.',
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _itens.add(
                              _ChecklistItem(
                                titulo: nome,
                                categoria: categoria,
                                concluido: false,
                                icon: _iconeCategoria(categoria),
                              ),
                            );
                            _categoriaSelecionada = 'Todos';
                          });

                          Navigator.pop(sheetContext);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar item'),
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

    controller.dispose();
  }

  void _abrirDetalhes(_ChecklistItem item) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      item.icon,
                      color: item.concluido
                          ? AppColors.success
                          : AppColors.primary,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.titulo,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.categoria,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(height: 28),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    item.concluido
                        ? Icons.check_circle_outline
                        : Icons.radio_button_unchecked,
                  ),
                  title: const Text('Status'),
                  subtitle: Text(
                    item.concluido ? 'Concluído' : 'Pendente',
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _alternarItem(item);
                    },
                    icon: Icon(
                      item.concluido ? Icons.undo : Icons.check,
                    ),
                    label: Text(
                      item.concluido
                          ? 'Marcar como pendente'
                          : 'Marcar como concluído',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _removerItem(item);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Excluir item'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removerItem(_ChecklistItem item) {
    final index = _itens.indexOf(item);
    if (index == -1) return;

    setState(() {
      _itens.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.titulo} removido.'),
        action: SnackBarAction(
          label: 'DESFAZER',
          onPressed: () {
            if (!mounted) return;

            setState(() {
              if (!_itens.contains(item)) {
                final posicao = index.clamp(0, _itens.length);
                _itens.insert(posicao, item);
              }
            });
          },
        ),
      ),
    );
  }

  void _abrirOpcoes() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.done_all,
                    color: AppColors.success,
                  ),
                  title: const Text('Marcar tudo como concluído'),
                  onTap: () {
                    setState(() {
                      for (final item in _itens) {
                        item.concluido = true;
                      }
                    });
                    Navigator.pop(sheetContext);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.restart_alt),
                  title: const Text('Desmarcar todos'),
                  onTap: () {
                    setState(() {
                      for (final item in _itens) {
                        item.concluido = false;
                      }
                    });
                    Navigator.pop(sheetContext);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_sweep_outlined,
                    color: AppColors.error,
                  ),
                  title: const Text('Limpar itens concluídos'),
                  onTap: () {
                    setState(() {
                      _itens.removeWhere((item) => item.concluido);
                    });
                    Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _iconeCategoria(String categoria) {
    switch (categoria) {
      case 'Documentos':
        return Icons.badge_outlined;
      case 'Reservas':
        return Icons.hotel_outlined;
      case 'Mala':
        return Icons.luggage_outlined;
      case 'Compras':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.travel_explore_outlined;
    }
  }
}

class _ChecklistItem {
  final String titulo;
  final String categoria;
  bool concluido;
  final IconData icon;

  _ChecklistItem({
    required this.titulo,
    required this.categoria,
    required this.concluido,
    required this.icon,
  });
}

class _ChecklistCard extends StatelessWidget {
  final _ChecklistItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _ChecklistCard({
    required this.item,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(item),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Row(
              children: [
                Checkbox(
                  value: item.concluido,
                  onChanged: (_) => onToggle(),
                ),
                const SizedBox(width: 4),
                Icon(
                  item.icon,
                  size: 24,
                  color: item.concluido
                      ? AppColors.success
                      : AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: item.concluido
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                          decoration: item.concluido
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.categoria,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
