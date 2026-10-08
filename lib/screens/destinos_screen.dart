import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class DestinosScreen extends StatefulWidget {
  const DestinosScreen({super.key});

  @override
  State<DestinosScreen> createState() => _DestinosScreenState();
}

class _DestinosScreenState extends State<DestinosScreen> {
  String _selectedFilter = 'Todos';

  final List<_Destino> _destinos = [
    const _Destino(
      nome: 'Torre Eiffel',
      cidade: 'Paris, França',
      categoria: 'Ponto turístico',
      descricao: 'Um dos principais símbolos de Paris.',
      icon: Icons.location_city,
      cor: Color(0xFF3B82F6),
    ),
    const _Destino(
      nome: 'Museu do Louvre',
      cidade: 'Paris, França',
      categoria: 'Cultura',
      descricao: 'Arte, história e uma das maiores coleções do mundo.',
      icon: Icons.museum_outlined,
      cor: Color(0xFFD6A84F),
    ),
    const _Destino(
      nome: 'Montmartre',
      cidade: 'Paris, França',
      categoria: 'Passeio',
      descricao: 'Bairro histórico conhecido por suas ruas e cafés.',
      icon: Icons.photo_camera_outlined,
      cor: Color(0xFF8B5CF6),
    ),
    const _Destino(
      nome: 'Jardim de Luxemburgo',
      cidade: 'Paris, França',
      categoria: 'Natureza',
      descricao: 'Um espaço tranquilo para caminhar e relaxar.',
      icon: Icons.park_outlined,
      cor: Color(0xFF4ADE80),
    ),
  ];

  final List<String> _filters = [
    'Todos',
    'Pontos turísticos',
    'Cultura',
    'Passeio',
    'Natureza',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinos'),
        actions: [
          IconButton(
            tooltip: 'Pesquisar',
            onPressed: () => _abrirPesquisa(),
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 40 : 20,
                  vertical: 12,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeader(context, isWide),
                    const SizedBox(height: 24),
                    _buildStats(),
                    const SizedBox(height: 28),
                    _buildFilters(),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
              _buildDestinationGrid(isWide),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  isWide ? 40 : 20,
                  28,
                  isWide ? 40 : 20,
                  100,
                ),
                sliver: SliverToBoxAdapter(
                  child: _buildTravelTip(),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirAdicionarDestino,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Adicionar destino'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isWide) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore sua viagem',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Organize os lugares que você quer conhecer durante sua viagem.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (isWide) ...[
          const SizedBox(width: 20),
          FilledButton.tonalIcon(
            onPressed: _abrirAdicionarDestino,
            icon: const Icon(Icons.add),
            label: const Text('Novo destino'),
          ),
        ],
      ],
    );
  }

  Widget _buildStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;

        final cards = [
          _StatCard(
            icon: Icons.place_outlined,
            value: '${_destinos.length}',
            label: 'Destinos',
            color: AppColors.primary,
          ),
          const _StatCard(
            icon: Icons.star_outline,
            value: '4.8',
            label: 'Avaliação média',
            color: AppColors.warning,
          ),
          const _StatCard(
            icon: Icons.check_circle_outline,
            value: '2',
            label: 'Visitados',
            color: AppColors.success,
          ),
        ];

        if (isCompact) {
          return Column(
            children: cards
                .map(
                  (card) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: card,
              ),
            )
                .toList(),
          );
        }

        return Row(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              Expanded(child: cards[i]),
              if (i != cards.length - 1) const SizedBox(width: 12),
            ],
          ],
        );
      },
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];

          return ChoiceChip(
            label: Text(filter),
            selected: _selectedFilter == filter,
            onSelected: (_) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildDestinationGrid(bool isWide) {
    final filteredDestinos = _destinos.where((destino) {
      if (_selectedFilter == 'Todos') return true;
      return destino.categoria == _selectedFilter;
    }).toList();

    if (filteredDestinos.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverToBoxAdapter(
          child: _buildEmptyFilterState(),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 40 : 20,
      ),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final destino = filteredDestinos[index];

            return _DestinoCard(
              destino: destino,
              onTap: () => _abrirDetalhes(destino),
              onFavorite: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${destino.nome} adicionado aos favoritos.',
                    ),
                  ),
                );
              },
            );
          },
          childCount: filteredDestinos.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isWide ? 3 : 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isWide ? 1.35 : 1.65,
        ),
      ),
    );
  }

  Widget _buildEmptyFilterState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(
              Icons.search_off_outlined,
              size: 48,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhum destino encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Não há destinos nessa categoria.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'Todos';
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
        padding: const EdgeInsets.all(22),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dica de viagem',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Agrupe destinos próximos no mesmo dia para aproveitar melhor o tempo e reduzir deslocamentos.',
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

  void _abrirPesquisa() {
    showSearch(
      context: context,
      delegate: _DestinoSearchDelegate(_destinos),
    );
  }

  void _abrirDetalhes(_Destino destino) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: destino.cor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        destino.icon,
                        color: destino.cor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            destino.nome,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            destino.cidade,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
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
                Text(
                  destino.categoria,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  destino.descricao,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Destino adicionado ao roteiro.'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.route_outlined),
                        label: const Text('Adicionar ao roteiro'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Destino salvo nos favoritos.'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.favorite_border),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _abrirAdicionarDestino() {
    final nomeController = TextEditingController();
    final cidadeController = TextEditingController();
    final descricaoController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (context) {
        String categoriaSelecionada = 'Passeio';

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
                      'Novo destino',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Adicione um lugar que você deseja conhecer.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: nomeController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nome do destino',
                        prefixIcon: Icon(Icons.place_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: cidadeController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Cidade e país',
                        prefixIcon: Icon(Icons.public),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: descricaoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        prefixIcon: Icon(Icons.notes_outlined),
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
                          'Passeio',
                          'Cultura',
                          'Natureza',
                          'Ponto turístico',
                        ])
                          ChoiceChip(
                            label: Text(categoria),
                            selected: categoriaSelecionada == categoria,
                            onSelected: (_) {
                              setModalState(() {
                                categoriaSelecionada = categoria;
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
                          if (nomeController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Digite o nome do destino.',
                                ),
                              ),
                            );
                            return;
                          }

                          Navigator.pop(context);

                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${nomeController.text.trim()} foi adicionado à viagem.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_location_alt_outlined),
                        label: const Text('Adicionar destino'),
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
}

class _Destino {
  final String nome;
  final String cidade;
  final String categoria;
  final String descricao;
  final IconData icon;
  final Color cor;

  const _Destino({
    required this.nome,
    required this.cidade,
    required this.categoria,
    required this.descricao,
    required this.icon,
    required this.cor,
  });
}

class _DestinoCard extends StatelessWidget {
  final _Destino destino;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _DestinoCard({
    required this.destino,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: destino.cor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      destino.icon,
                      color: destino.cor,
                      size: 27,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Favoritar',
                    onPressed: onFavorite,
                    icon: const Icon(Icons.favorite_border),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                destino.categoria.toUpperCase(),
                style: TextStyle(
                  color: destino.cor,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                destino.nome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      destino.cidade,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinoSearchDelegate extends SearchDelegate<_Destino?> {
  final List<_Destino> destinos;

  _DestinoSearchDelegate(this.destinos);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResults();
  }

  Widget _buildResults() {
    final resultados = destinos.where((destino) {
      final termo = query.toLowerCase();

      return destino.nome.toLowerCase().contains(termo) ||
          destino.cidade.toLowerCase().contains(termo) ||
          destino.categoria.toLowerCase().contains(termo);
    }).toList();

    if (resultados.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum destino encontrado.',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: resultados.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final destino = resultados[index];

        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          tileColor: AppColors.surface,
          leading: CircleAvatar(
            backgroundColor: destino.cor.withValues(alpha: 0.14),
            child: Icon(
              destino.icon,
              color: destino.cor,
            ),
          ),
          title: Text(destino.nome),
          subtitle: Text(destino.cidade),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => close(context, destino),
        );
      },
    );
  }
}