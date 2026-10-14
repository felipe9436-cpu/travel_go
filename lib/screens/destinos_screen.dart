
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class DestinosScreen extends StatefulWidget {
  const DestinosScreen({super.key});

  @override
  State<DestinosScreen> createState() => _DestinosScreenState();
}

class _DestinosScreenState extends State<DestinosScreen> {
  String _filtroSelecionado = 'Todos';
  String _termoPesquisa = '';

  final List<_Destino> _destinos = [];

  final List<String> _categorias = [
    'Todos',
    'Ponto turístico',
    'Cultura',
    'Passeio',
    'Natureza',
    'Hospedagem',
    'Restaurante',
    'Transporte',
  ];

  List<_Destino> get _destinosFiltrados {
    return _destinos.where((destino) {
      final correspondeCategoria =
          _filtroSelecionado == 'Todos' ||
              destino.categoria == _filtroSelecionado;

      final termo = _termoPesquisa.trim().toLowerCase();

      final correspondePesquisa =
          termo.isEmpty ||
              destino.nome.toLowerCase().contains(termo) ||
              destino.cidade.toLowerCase().contains(termo) ||
              destino.categoria.toLowerCase().contains(termo);

      return correspondeCategoria && correspondePesquisa;
    }).toList();
  }

  int get _totalFavoritos =>
      _destinos.where((destino) => destino.favorito).length;

  int get _totalVisitados =>
      _destinos.where((destino) => destino.visitado).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Destinos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Pesquisar destinos',
            onPressed: _abrirPesquisa,
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final largura = constraints.maxWidth;
          final colunas = largura >= 1100
              ? 3
              : largura >= 650
              ? 2
              : 1;

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  largura >= 900 ? 36 : 20,
                  20,
                  largura >= 900 ? 36 : 20,
                  24,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCabecalho(context, largura >= 650),
                      const SizedBox(height: 24),
                      _buildPesquisa(),
                      const SizedBox(height: 20),
                      _buildEstatisticas(largura < 600),
                      const SizedBox(height: 28),
                      _buildTituloSecao(),
                      const SizedBox(height: 14),
                      _buildFiltros(),
                    ],
                  ),
                ),
              ),
              _buildListaDestinos(colunas, largura),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  largura >= 900 ? 36 : 20,
                  24,
                  largura >= 900 ? 36 : 20,
                  100,
                ),
                sliver: SliverToBoxAdapter(
                  child: _buildDicaViagem(),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarDestino,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Adicionar destino'),
      ),
    );
  }

  Widget _buildCabecalho(BuildContext context, bool mostrarBotao) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore novos lugares',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Reúna os lugares que deseja conhecer e organize '
                    'suas próximas experiências.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        if (mostrarBotao) ...[
          const SizedBox(width: 16),
          IconButton.filledTonal(
            tooltip: 'Novo destino',
            onPressed: _adicionarDestino,
            icon: const Icon(Icons.add),
          ),
        ],
      ],
    );
  }

  Widget _buildPesquisa() {
    return TextField(
      onChanged: (valor) {
        setState(() {
          _termoPesquisa = valor;
        });
      },
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Buscar por lugar, cidade ou categoria...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _termoPesquisa.isNotEmpty
            ? IconButton(
          tooltip: 'Limpar pesquisa',
          onPressed: () {
            setState(() {
              _termoPesquisa = '';
            });
          },
          icon: const Icon(Icons.close),
        )
            : null,
      ),
    );
  }

  Widget _buildEstatisticas(bool compacto) {
    final cards = [
      _StatCard(
        icon: Icons.place_outlined,
        valor: '${_destinos.length}',
        titulo: 'Destinos',
        cor: AppColors.primary,
      ),
      _StatCard(
        icon: Icons.favorite_border,
        valor: '$_totalFavoritos',
        titulo: 'Favoritos',
        cor: AppColors.error,
      ),
      _StatCard(
        icon: Icons.check_circle_outline,
        valor: '$_totalVisitados',
        titulo: 'Visitados',
        cor: AppColors.success,
      ),
    ];

    if (compacto) {
      return Row(
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            Expanded(child: cards[i]),
            if (i != cards.length - 1) const SizedBox(width: 8),
          ],
        ],
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
  }

  Widget _buildTituloSecao() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Seus destinos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          '${_destinosFiltrados.length} '
              '${_destinosFiltrados.length == 1 ? 'lugar' : 'lugares'}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildFiltros() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categorias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final categoria = _categorias[index];

          return ChoiceChip(
            label: Text(categoria),
            selected: _filtroSelecionado == categoria,
            showCheckmark: false,
            onSelected: (_) {
              setState(() {
                _filtroSelecionado = categoria;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildListaDestinos(int colunas, double largura) {
    final destinos = _destinosFiltrados;

    if (destinos.isEmpty) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: largura >= 900 ? 36 : 20,
        ),
        sliver: SliverToBoxAdapter(
          child: _buildEstadoVazio(),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: largura >= 900 ? 36 : 20,
      ),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final destino = destinos[index];

            return _DestinoCard(
              destino: destino,
              onTap: () => _abrirDetalhes(destino),
              onFavorito: () => _alternarFavorito(destino),
            );
          },
          childCount: destinos.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: colunas,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: colunas == 1 ? 190 : 210,
        ),
      ),
    );
  }

  Widget _buildEstadoVazio() {
    final temDestinos = _destinos.isNotEmpty;
    final temPesquisa = _termoPesquisa.trim().isNotEmpty;

    String titulo;
    String descricao;
    IconData icone;

    if (!temDestinos) {
      titulo = 'Sua próxima aventura começa aqui';
      descricao =
      'Adicione seu primeiro destino para começar a organizar '
          'os lugares que deseja conhecer.';
      icone = Icons.explore_outlined;
    } else if (temPesquisa) {
      titulo = 'Nenhum resultado encontrado';
      descricao =
      'Tente pesquisar outro nome, cidade ou categoria.';
      icone = Icons.search_off_outlined;
    } else {
      titulo = 'Nenhum destino nesta categoria';
      descricao =
      'Escolha outra categoria ou veja todos os seus destinos.';
      icone = Icons.location_off_outlined;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 36,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              icone,
              size: 34,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            descricao,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          if (!temDestinos)
            FilledButton.icon(
              onPressed: _adicionarDestino,
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Adicionar primeiro destino'),
            )
          else
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _filtroSelecionado = 'Todos';
                  _termoPesquisa = '';
                });
              },
              child: const Text('Limpar filtros'),
            ),
        ],
      ),
    );
  }

  Widget _buildDicaViagem() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: AppColors.primary,
            size: 26,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dica de viagem',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Agrupe lugares próximos no mesmo dia para aproveitar '
                      'melhor o tempo e facilitar os deslocamentos.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _abrirPesquisa() async {
    final destino = await showSearch<_Destino?>(
      context: context,
      delegate: _DestinoSearchDelegate(_destinos),
    );

    if (!mounted || destino == null) return;

    _abrirDetalhes(destino);
  }

  void _alternarFavorito(_Destino destino) {
    setState(() {
      destino.favorito = !destino.favorito;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          destino.favorito
              ? '${destino.nome} adicionado aos favoritos.'
              : '${destino.nome} removido dos favoritos.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _alternarVisitado(_Destino destino) {
    setState(() {
      destino.visitado = !destino.visitado;
    });
  }

  void _alternarRoteiro(_Destino destino) {
    setState(() {
      destino.noRoteiro = !destino.noRoteiro;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          destino.noRoteiro
              ? '${destino.nome} marcado para o roteiro.'
              : '${destino.nome} removido do roteiro.',
        ),
      ),
    );
  }

  void _abrirDetalhes(_Destino destino) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: destino.cor.withOpacity(0.13),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            destino.icone,
                            color: destino.cor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                destino.nome,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
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
                          tooltip: 'Fechar',
                          onPressed: () => Navigator.pop(sheetContext),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text(destino.categoria),
                        avatar: Icon(
                          destino.icone,
                          size: 17,
                          color: destino.cor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      destino.descricao.isEmpty
                          ? 'Nenhuma descrição foi adicionada para este destino.'
                          : destino.descricao,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            destino.visitado
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: destino.visitado
                                ? AppColors.success
                                : AppColors.textMuted,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text('Já visitei este lugar'),
                          ),
                          Switch(
                            value: destino.visitado,
                            onChanged: (_) {
                              _alternarVisitado(destino);
                              setModalState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          _alternarRoteiro(destino);
                          setModalState(() {});
                        },
                        icon: Icon(
                          destino.noRoteiro
                              ? Icons.remove_circle_outline
                              : Icons.route_outlined,
                        ),
                        label: Text(
                          destino.noRoteiro
                              ? 'Remover do roteiro'
                              : 'Adicionar ao roteiro',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _alternarFavorito(destino);
                          setModalState(() {});
                        },
                        icon: Icon(
                          destino.favorito
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: destino.favorito
                              ? AppColors.error
                              : null,
                        ),
                        label: Text(
                          destino.favorito
                              ? 'Remover dos favoritos'
                              : 'Salvar nos favoritos',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _confirmarRemocao(destino);
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Excluir destino'),
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

  Future<void> _adicionarDestino() async {
    final nomeController = TextEditingController();
    final cidadeController = TextEditingController();
    final descricaoController = TextEditingController();

    String categoriaSelecionada = 'Passeio';
    String? erro;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
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
                        'Adicionar destino',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Cadastre um lugar que deseja conhecer.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 22),
                      TextField(
                        controller: nomeController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Nome do destino *',
                          hintText: 'Ex.: Parque Ibirapuera',
                          prefixIcon: Icon(Icons.place_outlined),
                        ),
                        onChanged: (_) {
                          if (erro != null) {
                            setModalState(() => erro = null);
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: cidadeController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Cidade e país',
                          hintText: 'Ex.: São Paulo, Brasil',
                          prefixIcon: Icon(Icons.public),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: descricaoController,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Descrição (opcional)',
                          hintText: 'O que você deseja conhecer?',
                          prefixIcon: Icon(Icons.notes_outlined),
                          alignLabelWithHint: true,
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
                          for (final categoria in _categorias.skip(1))
                            ChoiceChip(
                              label: Text(categoria),
                              selected:
                              categoriaSelecionada == categoria,
                              showCheckmark: false,
                              onSelected: (_) {
                                setModalState(() {
                                  categoriaSelecionada = categoria;
                                });
                              },
                            ),
                        ],
                      ),
                      if (erro != null) ...[
                        const SizedBox(height: 14),
                        Text(
                          erro!,
                          style: const TextStyle(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            final nome = nomeController.text.trim();
                            final cidade = cidadeController.text.trim();

                            if (nome.isEmpty) {
                              setModalState(() {
                                erro = 'Informe o nome do destino.';
                              });
                              return;
                            }

                            final repetido = _destinos.any(
                                  (destino) =>
                              destino.nome.toLowerCase() ==
                                  nome.toLowerCase() &&
                                  destino.cidade.toLowerCase() ==
                                      cidade.toLowerCase(),
                            );

                            if (repetido) {
                              setModalState(() {
                                erro = 'Este destino já está cadastrado.';
                              });
                              return;
                            }

                            final novoDestino = _Destino(
                              nome: nome,
                              cidade: cidade.isEmpty
                                  ? 'Localização não informada'
                                  : cidade,
                              categoria: categoriaSelecionada,
                              descricao:
                              descricaoController.text.trim(),
                              icone: _iconeCategoria(categoriaSelecionada),
                              cor: _corCategoria(categoriaSelecionada),
                            );

                            setState(() {
                              _destinos.insert(0, novoDestino);
                              _filtroSelecionado = 'Todos';
                              _termoPesquisa = '';
                            });

                            Navigator.pop(sheetContext);

                            ScaffoldMessenger.of(this.context)
                                .showSnackBar(
                              SnackBar(
                                content: Text('$nome adicionado aos destinos.'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_location_alt_outlined),
                          label: const Text('Salvar destino'),
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
    );

    nomeController.dispose();
    cidadeController.dispose();
    descricaoController.dispose();
  }

  Future<void> _confirmarRemocao(_Destino destino) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir destino?'),
          content: Text(
            'Deseja remover "${destino.nome}" da sua lista?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    final index = _destinos.indexOf(destino);
    if (index == -1) return;

    setState(() {
      _destinos.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${destino.nome} removido.'),
        action: SnackBarAction(
          label: 'DESFAZER',
          onPressed: () {
            if (!mounted) return;
            setState(() {
              _destinos.insert(
                index.clamp(0, _destinos.length),
                destino,
              );
            });
          },
        ),
      ),
    );
  }

  IconData _iconeCategoria(String categoria) {
    switch (categoria) {
      case 'Ponto turístico':
        return Icons.location_city_outlined;
      case 'Cultura':
        return Icons.museum_outlined;
      case 'Natureza':
        return Icons.park_outlined;
      case 'Hospedagem':
        return Icons.hotel_outlined;
      case 'Restaurante':
        return Icons.restaurant_outlined;
      case 'Transporte':
        return Icons.directions_transit_outlined;
      default:
        return Icons.explore_outlined;
    }
  }

  Color _corCategoria(String categoria) {
    switch (categoria) {
      case 'Ponto turístico':
        return AppColors.primary;
      case 'Cultura':
        return const Color(0xFF9B8AFB);
      case 'Natureza':
        return AppColors.success;
      case 'Hospedagem':
        return AppColors.blue;
      case 'Restaurante':
        return const Color(0xFFFB923C);
      case 'Transporte':
        return AppColors.cyan;
      default:
        return AppColors.primaryLight;
    }
  }
}

class _Destino {
  final String nome;
  final String cidade;
  final String categoria;
  final String descricao;
  final IconData icone;
  final Color cor;

  bool favorito;
  bool visitado;
  bool noRoteiro;

  _Destino({
    required this.nome,
    required this.cidade,
    required this.categoria,
    required this.descricao,
    required this.icone,
    required this.cor,
    this.favorito = false,
    this.visitado = false,
    this.noRoteiro = false,
  });
}

class _DestinoCard extends StatelessWidget {
  final _Destino destino;
  final VoidCallback onTap;
  final VoidCallback onFavorito;

  const _DestinoCard({
    required this.destino,
    required this.onTap,
    required this.onFavorito,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: destino.cor.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  destino.icone,
                  color: destino.cor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destino.categoria.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: destino.cor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      destino.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            destino.cidade,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (destino.visitado || destino.noRoteiro) ...[
                      const SizedBox(height: 7),
                      Wrap(
                        spacing: 6,
                        children: [
                          if (destino.visitado)
                            const _StatusTag(
                              texto: 'Visitado',
                              cor: AppColors.success,
                            ),
                          if (destino.noRoteiro)
                            const _StatusTag(
                              texto: 'No roteiro',
                              cor: AppColors.primary,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: destino.favorito
                        ? 'Remover favorito'
                        : 'Adicionar favorito',
                    onPressed: onFavorito,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      destino.favorito
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: destino.favorito
                          ? AppColors.error
                          : AppColors.textMuted,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
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

class _StatusTag extends StatelessWidget {
  final String texto;
  final Color cor;

  const _StatusTag({
    required this.texto,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: cor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String valor;
  final String titulo;
  final Color cor;

  const _StatCard({
    required this.icon,
    required this.valor,
    required this.titulo,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: cor, size: 23),
          const SizedBox(height: 9),
          Text(
            valor,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            titulo,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _DestinoSearchDelegate extends SearchDelegate<_Destino?> {
  final List<_Destino> destinos;

  _DestinoSearchDelegate(this.destinos);

  @override
  String get searchFieldLabel => 'Pesquisar destinos';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'Limpar pesquisa',
          onPressed: () => query = '',
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Voltar',
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildResultados(context);

  @override
  Widget buildSuggestions(BuildContext context) =>
      _buildResultados(context);

  Widget _buildResultados(BuildContext context) {
    final termo = query.trim().toLowerCase();

    final resultados = destinos.where((destino) {
      return destino.nome.toLowerCase().contains(termo) ||
          destino.cidade.toLowerCase().contains(termo) ||
          destino.categoria.toLowerCase().contains(termo);
    }).toList();

    if (resultados.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Nenhum destino encontrado.\nExperimente outro termo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: resultados.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final destino = resultados[index];

        return Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: destino.cor.withOpacity(0.13),
              child: Icon(destino.icone, color: destino.cor),
            ),
            title: Text(
              destino.nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(destino.cidade),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => close(context, destino),
          ),
        );
      },
    );
  }
}
