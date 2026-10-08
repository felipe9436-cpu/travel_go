import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final List<_ChecklistItem> _itens = [
    _ChecklistItem(
      titulo: 'Passaporte',
      categoria: 'Documentos',
      concluido: true,
      icon: Icons.badge_outlined,
    ),
    _ChecklistItem(
      titulo: 'Seguro viagem',
      categoria: 'Documentos',
      concluido: true,
      icon: Icons.shield_outlined,
    ),
    _ChecklistItem(
      titulo: 'Reserva do hotel',
      categoria: 'Reservas',
      concluido: true,
      icon: Icons.hotel_outlined,
    ),
    _ChecklistItem(
      titulo: 'Comprar adaptador de tomada',
      categoria: 'Compras',
      concluido: false,
      icon: Icons.power_outlined,
    ),
    _ChecklistItem(
      titulo: 'Separar roupas',
      categoria: 'Mala',
      concluido: false,
      icon: Icons.luggage_outlined,
    ),
    _ChecklistItem(
      titulo: 'Carregador do celular',
      categoria: 'Mala',
      concluido: false,
      icon: Icons.battery_charging_full_outlined,
    ),
    _ChecklistItem(
      titulo: 'Fazer check-in do voo',
      categoria: 'Viagem',
      concluido: false,
      icon: Icons.flight_takeoff_outlined,
    ),
    _ChecklistItem(
      titulo: 'Baixar mapas offline',
      categoria: 'Viagem',
      concluido: false,
      icon: Icons.map_outlined,
    ),
  ];

  final List<String> _categorias = [
    'Todos',
    'Documentos',
    'Reservas',
    'Mala',
    'Compras',
    'Viagem',
  ];

  String _categoriaSelecionada = 'Todos';

  int get _concluidos {
    return _itens.where((item) => item.concluido).length;
  }

  int get _totalItens => _itens.length;

  double get _progresso {
    if (_totalItens == 0) return 0;

    return _concluidos / _totalItens;
  }

  List<_ChecklistItem> get _itensFiltrados {
    if (_categoriaSelecionada == 'Todos') {
      return _itens;
    }

    return _itens
        .where(
          (item) => item.categoria == _categoriaSelecionada,
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
                'Checklist',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              actions: [
                IconButton.filledTonal(
                  tooltip: 'Opções',
                  onPressed: _abrirOpcoes,
                  icon: const Icon(
                    Icons.more_horiz,
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
                  _buildProgressCard(),
                  const SizedBox(height: 26),
                  _buildCategoryFilters(),
                  const SizedBox(height: 24),
                  _buildListHeader(),
                ]),
              ),
            ),
            _buildItemsList(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                26,
                20,
                100,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildTravelTip(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarItem,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar item'),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tudo pronto para viajar?',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 7),
        const Text(
          'Organize documentos, malas, reservas e tudo o que precisa fazer antes da viagem.',
          style: TextStyle(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    final completo = _totalItens > 0 &&
        _concluidos == _totalItens;

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
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: completo
                        ? AppColors.success.withValues(alpha: 0.14)
                        : AppColors.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    completo
                        ? Icons.check_circle_outline
                        : Icons.checklist_rounded,
                    color: completo
                        ? AppColors.success
                        : AppColors.primary,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        completo
                            ? 'Tudo pronto!'
                            : 'Progresso da viagem',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        completo
                            ? 'Você completou todos os itens.'
                            : '$_concluidos de $_totalItens itens concluídos',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(_progresso * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: completo
                        ? AppColors.success
                        : AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: _progresso,
                minHeight: 9,
                backgroundColor: AppColors.border,
                color: completo
                    ? AppColors.success
                    : AppColors.primary,
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
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 43,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categorias.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final categoria = _categorias[index];

          return ChoiceChip(
            label: Text(categoria),
            selected:
            _categoriaSelecionada == categoria,
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

  Widget _buildListHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Itens da viagem',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Toque em um item para marcar como concluído',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Text(
          '$_concluidos/$_totalItens',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList() {
    final itens = _itensFiltrados;

    if (itens.isEmpty) {
      return SliverPadding(
        padding:
        const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverToBoxAdapter(
          child: _buildEmptyState(),
        ),
      );
    }

    return SliverPadding(
      padding:
      const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final item = itens[index];

            return Padding(
              padding:
              const EdgeInsets.only(bottom: 10),
              child: _ChecklistCard(
                item: item,
                onToggle: () => _alternarItem(item),
                onDelete: () => _removerItem(item),
                onTap: () => _abrirDetalhes(item),
              ),
            );
          },
          childCount: itens.length,
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
              Icons.checklist_outlined,
              color: AppColors.textMuted,
              size: 48,
            ),
            const SizedBox(height: 15),
            const Text(
              'Nenhum item encontrado',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Essa categoria ainda não possui itens.',
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

  Widget _buildTravelTip() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(21),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color:
                AppColors.cyan.withValues(alpha: 0.12),
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                color: AppColors.cyan,
              ),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dica de viagem',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Separe documentos importantes e faça uma cópia digital antes de sair. Assim você evita problemas caso perca algum documento.',
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

  void _alternarItem(_ChecklistItem item) {
    setState(() {
      item.concluido = !item.concluido;
    });

    if (item.concluido) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${item.titulo} concluído!',
          ),
          duration:
          const Duration(milliseconds: 1300),
        ),
      );
    }
  }

  void _adicionarItem() {
    final controller = TextEditingController();
    String categoria = 'Viagem';

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
                MediaQuery.viewInsetsOf(context).bottom +
                    24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Novo item',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Adicione algo que você precisa fazer ou levar.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      decoration:
                      const InputDecoration(
                        labelText: 'Nome do item',
                        hintText:
                        'Ex.: Comprar seguro viagem',
                        prefixIcon: Icon(
                          Icons.checklist_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                        for (final itemCategoria in [
                          'Documentos',
                          'Reservas',
                          'Mala',
                          'Compras',
                          'Viagem',
                        ])
                          ChoiceChip(
                            label: Text(itemCategoria),
                            selected:
                            categoria ==
                                itemCategoria,
                            onSelected: (_) {
                              setModalState(() {
                                categoria =
                                    itemCategoria;
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
                          final nome =
                          controller.text.trim();

                          if (nome.isEmpty) {
                            return;
                          }

                          setState(() {
                            _itens.add(
                              _ChecklistItem(
                                titulo: nome,
                                categoria: categoria,
                                concluido: false,
                                icon: _iconeCategoria(
                                  categoria,
                                ),
                              ),
                            );
                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(
                            this.context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Item adicionado ao checklist.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Adicionar item',
                        ),
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

  void _abrirDetalhes(_ChecklistItem item) {
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
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: item.concluido
                            ? AppColors.success
                            .withValues(alpha: 0.12)
                            : AppColors.primary
                            .withValues(alpha: 0.12),
                        borderRadius:
                        BorderRadius.circular(17),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.concluido
                            ? AppColors.success
                            : AppColors.primary,
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
                            item.titulo,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge,
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
                    IconButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _InfoRow(
                  icon: Icons.category_outlined,
                  title: 'Categoria',
                  value: item.categoria,
                ),
                const SizedBox(height: 14),
                _InfoRow(
                  icon: item.concluido
                      ? Icons.check_circle_outline
                      : Icons.radio_button_unchecked,
                  title: 'Status',
                  value: item.concluido
                      ? 'Concluído'
                      : 'Pendente',
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _alternarItem(item);
                    },
                    icon: Icon(
                      item.concluido
                          ? Icons.undo
                          : Icons.check,
                    ),
                    label: Text(
                      item.concluido
                          ? 'Marcar como pendente'
                          : 'Marcar como concluído',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _removerItem(item);
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
                    label: const Text(
                      'Excluir item',
                    ),
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
        content: Text(
          '${item.titulo} removido.',
        ),
        action: SnackBarAction(
          label: 'DESFAZER',
          onPressed: () {
            setState(() {
              _itens.insert(index, item);
            });
          },
        ),
      ),
    );
  }

  void _abrirOpcoes() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              8,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.done_all,
                    color: AppColors.success,
                  ),
                  title: const Text(
                    'Marcar tudo como concluído',
                  ),
                  onTap: () {
                    setState(() {
                      for (final item in _itens) {
                        item.concluido = true;
                      }
                    });

                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.restart_alt,
                  ),
                  title: const Text(
                    'Desmarcar todos',
                  ),
                  onTap: () {
                    setState(() {
                      for (final item in _itens) {
                        item.concluido = false;
                      }
                    });

                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_sweep_outlined,
                    color: AppColors.error,
                  ),
                  title: const Text(
                    'Limpar itens concluídos',
                  ),
                  onTap: () {
                    setState(() {
                      _itens.removeWhere(
                            (item) => item.concluido,
                      );
                    });

                    Navigator.pop(context);
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
      key: ValueKey(
        '${item.titulo}_${item.categoria}',
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
        padding:
        const EdgeInsets.only(right: 24),
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
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            child: Row(
              children: [
                Checkbox(
                  value: item.concluido,
                  onChanged: (_) => onToggle(),
                ),
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: item.concluido
                        ? AppColors.success
                        .withValues(alpha: 0.10)
                        : AppColors.surfaceElevated,
                    borderRadius:
                    BorderRadius.circular(13),
                  ),
                  child: Icon(
                    item.icon,
                    size: 21,
                    color: item.concluido
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.titulo,
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          color: item.concluido
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          decoration: item.concluido
                              ? TextDecoration
                              .lineThrough
                              : null,
                          decorationColor:
                          AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.categoria,
                        style: TextStyle(
                          color: item.concluido
                              ? AppColors.textMuted
                              : AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                  size: 19,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
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
            crossAxisAlignment:
            CrossAxisAlignment.start,
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