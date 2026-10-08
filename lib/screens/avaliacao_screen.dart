import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AvaliacaoScreen extends StatefulWidget {
  const AvaliacaoScreen({super.key});

  @override
  State<AvaliacaoScreen> createState() => _AvaliacaoScreenState();
}

class _AvaliacaoScreenState extends State<AvaliacaoScreen> {
  final List<_Avaliacao> _avaliacoes = [
    const _Avaliacao(
      titulo: 'Torre Eiffel',
      categoria: 'Destino',
      nota: 5,
      comentario:
      'Uma experiência incrível. A vista da cidade é fantástica.',
      data: '14 Dez',
      icon: Icons.location_on_outlined,
      cor: AppColors.primary,
    ),
    const _Avaliacao(
      titulo: 'Le Central Hotel',
      categoria: 'Hospedagem',
      nota: 4,
      comentario:
      'Ótima localização e quarto confortável. O café da manhã poderia ter mais opções.',
      data: '13 Dez',
      icon: Icons.hotel_outlined,
      cor: AppColors.blue,
    ),
    const _Avaliacao(
      titulo: 'Le Petit Café',
      categoria: 'Restaurante',
      nota: 5,
      comentario:
      'Comida excelente e ambiente muito agradável.',
      data: '13 Dez',
      icon: Icons.restaurant_outlined,
      cor: AppColors.success,
    ),
    const _Avaliacao(
      titulo: 'Museu do Louvre',
      categoria: 'Passeio',
      nota: 4,
      comentario:
      'Muito grande e cheio de atrações. Vale reservar bastante tempo.',
      data: '12 Dez',
      icon: Icons.museum_outlined,
      cor: Color(0xFF8B5CF6),
    ),
  ];

  final List<String> _categorias = [
    'Todas',
    'Destino',
    'Hospedagem',
    'Restaurante',
    'Passeio',
    'Transporte',
  ];

  String _categoriaSelecionada = 'Todas';

  double get _mediaAvaliacoes {
    if (_avaliacoes.isEmpty) return 0;

    final total = _avaliacoes.fold<double>(
      0,
          (total, avaliacao) => total + avaliacao.nota,
    );

    return total / _avaliacoes.length;
  }

  List<_Avaliacao> get _avaliacoesFiltradas {
    if (_categoriaSelecionada == 'Todas') {
      return _avaliacoes;
    }

    return _avaliacoes
        .where(
          (avaliacao) =>
      avaliacao.categoria == _categoriaSelecionada,
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
                'Avaliações',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              actions: [
                IconButton.filledTonal(
                  tooltip: 'Estatísticas',
                  onPressed: _abrirEstatisticas,
                  icon: const Icon(
                    Icons.bar_chart_outlined,
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
                  _buildRatingOverview(),
                  const SizedBox(height: 26),
                  _buildCategoryFilters(),
                  const SizedBox(height: 24),
                  _buildListHeader(),
                ]),
              ),
            ),
            _buildReviewsList(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                28,
                20,
                100,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildReviewTip(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarAvaliacao,
        icon: const Icon(Icons.star_outline),
        label: const Text('Nova avaliação'),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suas experiências',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 7),
        const Text(
          'Registre o que achou dos lugares e serviços da sua viagem.',
          style: TextStyle(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingOverview() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
        ),
        child: Row(
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(
                  alpha: 0.12,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _mediaAvaliacoes.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Icon(
                    Icons.star,
                    color: AppColors.primary,
                    size: 17,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Média da viagem',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${_avaliacoes.length} avaliações registradas',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 11),
                  _buildStars(_mediaAvaliacoes.round()),
                ],
              ),
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
                'Avaliações recentes',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Suas experiências durante a viagem',
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
          onSelected: _ordenarAvaliacoes,
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'maior',
              child: Text('Maior nota'),
            ),
            PopupMenuItem(
              value: 'menor',
              child: Text('Menor nota'),
            ),
            PopupMenuItem(
              value: 'recentes',
              child: Text('Mais recentes'),
            ),
          ],
          icon: const Icon(Icons.sort),
        ),
      ],
    );
  }

  Widget _buildReviewsList() {
    final avaliacoes = _avaliacoesFiltradas;

    if (avaliacoes.isEmpty) {
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
            final avaliacao = avaliacoes[index];

            return Padding(
              padding:
              const EdgeInsets.only(bottom: 12),
              child: _ReviewCard(
                avaliacao: avaliacao,
                onTap: () =>
                    _abrirDetalhes(avaliacao),
                onDelete: () =>
                    _removerAvaliacao(avaliacao),
              ),
            );
          },
          childCount: avaliacoes.length,
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
              Icons.rate_review_outlined,
              color: AppColors.textMuted,
              size: 48,
            ),
            const SizedBox(height: 15),
            const Text(
              'Nenhuma avaliação encontrada',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Ainda não existem avaliações nessa categoria.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _categoriaSelecionada = 'Todas';
                });
              },
              child: const Text('Ver todas'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewTip() {
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
                color: AppColors.primary.withValues(
                  alpha: 0.12,
                ),
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dica',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Avalie os lugares logo depois da experiência. Assim você consegue registrar detalhes enquanto ainda estão frescos na memória.',
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

  Widget _buildStars(int nota) {
    return Row(
      children: List.generate(
        5,
            (index) => Padding(
          padding:
          const EdgeInsets.only(right: 2),
          child: Icon(
            index < nota
                ? Icons.star_rounded
                : Icons.star_outline_rounded,
            color: AppColors.primary,
            size: 19,
          ),
        ),
      ),
    );
  }

  void _adicionarAvaliacao() {
    final tituloController = TextEditingController();
    final comentarioController =
    TextEditingController();

    String categoria = 'Destino';
    int nota = 5;
    DateTime data = DateTime.now();

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
                      'Nova avaliação',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Registre uma experiência da sua viagem.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: tituloController,
                      textInputAction:
                      TextInputAction.next,
                      decoration:
                      const InputDecoration(
                        labelText: 'Nome',
                        hintText:
                        'Ex.: Torre Eiffel',
                        prefixIcon: Icon(
                          Icons.place_outlined,
                        ),
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
                        for (final itemCategoria in [
                          'Destino',
                          'Hospedagem',
                          'Restaurante',
                          'Passeio',
                          'Transporte',
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
                    const SizedBox(height: 20),
                    const Text(
                      'Sua nota',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        5,
                            (index) {
                          final valor = index + 1;

                          return IconButton(
                            onPressed: () {
                              setModalState(() {
                                nota = valor;
                              });
                            },
                            iconSize: 34,
                            padding:
                            const EdgeInsets.all(3),
                            icon: Icon(
                              valor <= nota
                                  ? Icons.star_rounded
                                  : Icons
                                  .star_outline_rounded,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: comentarioController,
                      maxLines: 4,
                      decoration:
                      const InputDecoration(
                        labelText: 'Comentário',
                        hintText:
                        'Conte como foi sua experiência...',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final selecionada =
                        await showDatePicker(
                          context: context,
                          initialDate: data,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );

                        if (selecionada != null) {
                          setModalState(() {
                            data = selecionada;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                      ),
                      label: Text(
                        'Data: ${_formatarData(data)}',
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          final titulo =
                          tituloController.text
                              .trim();

                          if (titulo.isEmpty) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Informe o nome do local.',
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _avaliacoes.insert(
                              0,
                              _Avaliacao(
                                titulo: titulo,
                                categoria: categoria,
                                nota: nota,
                                comentario:
                                comentarioController
                                    .text
                                    .trim()
                                    .isEmpty
                                    ? 'Sem comentário.'
                                    : comentarioController
                                    .text
                                    .trim(),
                                data: _formatarData(data),
                                icon: _iconeCategoria(
                                  categoria,
                                ),
                                cor: _corCategoria(
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
                                'Avaliação adicionada.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.check,
                        ),
                        label: const Text(
                          'Salvar avaliação',
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

  void _abrirDetalhes(_Avaliacao avaliacao) {
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
                        color: avaliacao.cor.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius:
                        BorderRadius.circular(17),
                      ),
                      child: Icon(
                        avaliacao.icon,
                        color: avaliacao.cor,
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
                            avaliacao.titulo,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            avaliacao.categoria,
                            style: TextStyle(
                              color: avaliacao.cor,
                              fontWeight: FontWeight.w700,
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
                const SizedBox(height: 20),
                _buildStars(avaliacao.nota),
                const SizedBox(height: 18),
                Text(
                  avaliacao.comentario,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.55,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  title: 'Data',
                  value: avaliacao.data,
                ),
                const SizedBox(height: 14),
                _InfoRow(
                  icon: Icons.star_outline,
                  title: 'Nota',
                  value:
                  '${avaliacao.nota}/5 estrelas',
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _removerAvaliacao(avaliacao);
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
                    label: const Text(
                      'Excluir avaliação',
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

  void _abrirEstatisticas() {
    final cincoEstrelas = _avaliacoes
        .where((item) => item.nota == 5)
        .length;

    final quatroEstrelas = _avaliacoes
        .where((item) => item.nota == 4)
        .length;

    final tresOuMenos = _avaliacoes
        .where((item) => item.nota <= 3)
        .length;

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
                Text(
                  'Estatísticas',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Resumo das suas avaliações.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                _StatRow(
                  icon: Icons.star_rounded,
                  title: 'Média geral',
                  value:
                  _mediaAvaliacoes.toStringAsFixed(1),
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                _StatRow(
                  icon: Icons.star_rounded,
                  title: '5 estrelas',
                  value: '$cincoEstrelas',
                  color: AppColors.success,
                ),
                const SizedBox(height: 12),
                _StatRow(
                  icon: Icons.star_half_rounded,
                  title: '4 estrelas',
                  value: '$quatroEstrelas',
                  color: AppColors.blue,
                ),
                const SizedBox(height: 12),
                _StatRow(
                  icon: Icons.star_outline_rounded,
                  title: '3 ou menos',
                  value: '$tresOuMenos',
                  color: AppColors.warning,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removerAvaliacao(_Avaliacao avaliacao) {
    final index = _avaliacoes.indexOf(avaliacao);

    if (index == -1) return;

    setState(() {
      _avaliacoes.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${avaliacao.titulo} removido.',
        ),
        action: SnackBarAction(
          label: 'DESFAZER',
          onPressed: () {
            setState(() {
              _avaliacoes.insert(
                index,
                avaliacao,
              );
            });
          },
        ),
      ),
    );
  }

  void _ordenarAvaliacoes(String tipo) {
    setState(() {
      switch (tipo) {
        case 'maior':
          _avaliacoes.sort(
                (a, b) => b.nota.compareTo(a.nota),
          );
          break;

        case 'menor':
          _avaliacoes.sort(
                (a, b) => a.nota.compareTo(b.nota),
          );
          break;

        case 'recentes':
          break;
      }
    });
  }

  IconData _iconeCategoria(String categoria) {
    switch (categoria) {
      case 'Destino':
        return Icons.location_on_outlined;
      case 'Hospedagem':
        return Icons.hotel_outlined;
      case 'Restaurante':
        return Icons.restaurant_outlined;
      case 'Passeio':
        return Icons.local_activity_outlined;
      case 'Transporte':
        return Icons.directions_car_outlined;
      default:
        return Icons.star_outline;
    }
  }

  Color _corCategoria(String categoria) {
    switch (categoria) {
      case 'Destino':
        return AppColors.primary;
      case 'Hospedagem':
        return AppColors.blue;
      case 'Restaurante':
        return AppColors.success;
      case 'Passeio':
        return const Color(0xFF8B5CF6);
      case 'Transporte':
        return AppColors.cyan;
      default:
        return AppColors.textSecondary;
    }
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

class _Avaliacao {
  final String titulo;
  final String categoria;
  final int nota;
  final String comentario;
  final String data;
  final IconData icon;
  final Color cor;

  const _Avaliacao({
    required this.titulo,
    required this.categoria,
    required this.nota,
    required this.comentario,
    required this.data,
    required this.icon,
    required this.cor,
  });
}

class _ReviewCard extends StatelessWidget {
  final _Avaliacao avaliacao;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ReviewCard({
    required this.avaliacao,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(
        '${avaliacao.titulo}_${avaliacao.data}',
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
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: avaliacao.cor.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                      child: Icon(
                        avaliacao.icon,
                        color: avaliacao.cor,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            avaliacao.titulo,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              color:
                              AppColors.textPrimary,
                              fontWeight:
                              FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                avaliacao.categoria,
                                style: TextStyle(
                                  color:
                                  avaliacao.cor,
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),
                              const Padding(
                                padding:
                                EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  '•',
                                  style: TextStyle(
                                    color:
                                    AppColors
                                        .textMuted,
                                  ),
                                ),
                              ),
                              Text(
                                avaliacao.data,
                                style: const TextStyle(
                                  color:
                                  AppColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    ...List.generate(
                      5,
                          (index) => Icon(
                        index < avaliacao.nota
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${avaliacao.nota}/5',
                      style: const TextStyle(
                        color:
                        AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Text(
                  avaliacao.comentario,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.45,
                    fontSize: 13,
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
            borderRadius:
            BorderRadius.circular(12),
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

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius:
            BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: color,
            size: 21,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}