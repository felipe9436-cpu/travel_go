
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AvaliacaoScreen extends StatefulWidget {
  const AvaliacaoScreen({super.key});

  @override
  State<AvaliacaoScreen> createState() => _AvaliacaoScreenState();
}

class _AvaliacaoScreenState extends State<AvaliacaoScreen> {
  final List<_AvaliacaoLocal> _avaliacoes = [];

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

    final total = _avaliacoes.fold<int>(
      0,
          (soma, avaliacao) => soma + avaliacao.nota,
    );

    return total / _avaliacoes.length;
  }

  List<_AvaliacaoLocal> get _avaliacoesFiltradas {
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
    final avaliacoes = _avaliacoesFiltradas;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Avaliações',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Ordenar avaliações',
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _adicionarAvaliacao,
        icon: const Icon(Icons.add),
        label: const Text('Nova avaliação'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        children: [
          Text(
            'Suas experiências',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Registre e consulte suas opiniões sobre os lugares '
                'e serviços da viagem.',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // Resumo das avaliações.
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.primary,
                  size: 34,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Média das notas',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _mediaAvaliacoes.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 42,
                  color: AppColors.border,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registradas',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_avaliacoes.length}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

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
              separatorBuilder: (_, __) =>
              const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final categoria = _categorias[index];

                return ChoiceChip(
                  label: Text(categoria),
                  selected: _categoriaSelecionada == categoria,
                  onSelected: (_) {
                    setState(() {
                      _categoriaSelecionada = categoria;
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Suas avaliações',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${avaliacoes.length} itens',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (avaliacoes.isEmpty)
            _buildEstadoVazio()
          else
            ...avaliacoes.map(_buildCartaoAvaliacao),
        ],
      ),
    );
  }

  Widget _buildEstadoVazio() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.rate_review_outlined,
            size: 38,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 14),
          const Text(
            'Nenhuma avaliação por aqui',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adicione sua primeira avaliação para registrar '
                'como foi sua experiência.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _adicionarAvaliacao,
            icon: const Icon(Icons.add),
            label: const Text('Adicionar avaliação'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartaoAvaliacao(_AvaliacaoLocal avaliacao) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _mostrarDetalhes(avaliacao),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      avaliacao.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Excluir avaliação',
                    onPressed: () => _removerAvaliacao(avaliacao),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              Text(
                '${avaliacao.categoria} • '
                    '${_formatarData(avaliacao.data)}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ...List.generate(
                    5,
                        (index) => Icon(
                      index < avaliacao.nota
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: AppColors.primary,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${avaliacao.nota}/5',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (avaliacao.comentario.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  avaliacao.comentario,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _adicionarAvaliacao() async {
    final tituloController = TextEditingController();
    final comentarioController = TextEditingController();

    String categoria = 'Destino';
    int nota = 5;
    DateTime data = DateTime.now();

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
                      'Nova avaliação',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: tituloController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Nome do local ou serviço',
                        hintText: 'Ex.: Museu, hotel ou restaurante',
                        prefixIcon: Icon(Icons.place_outlined),
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: categoria,
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                      ),
                      items: _categorias
                          .where((item) => item != 'Todas')
                          .map(
                            (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                      )
                          .toList(),
                      onChanged: (valor) {
                        if (valor != null) {
                          setModalState(() {
                            categoria = valor;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Sua nota',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Row(
                      children: List.generate(5, (index) {
                        final valor = index + 1;

                        return IconButton(
                          onPressed: () {
                            setModalState(() {
                              nota = valor;
                            });
                          },
                          iconSize: 32,
                          icon: Icon(
                            valor <= nota
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: AppColors.primary,
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: comentarioController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Comentário (opcional)',
                        hintText: 'Conte como foi sua experiência',
                        alignLabelWithHint: true,
                      ),
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
                          setModalState(() {
                            data = selecionada;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text('Data: ${_formatarData(data)}'),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          final titulo = tituloController.text.trim();

                          if (titulo.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Informe o nome do local ou serviço.',
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _avaliacoes.insert(
                              0,
                              _AvaliacaoLocal(
                                titulo: titulo,
                                categoria: categoria,
                                nota: nota,
                                comentario:
                                comentarioController.text.trim(),
                                data: data,
                              ),
                            );

                            _categoriaSelecionada = 'Todas';
                          });

                          Navigator.pop(sheetContext);

                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Avaliação adicionada.'),
                            ),
                          );
                        },
                        child: const Text('Salvar avaliação'),
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

    tituloController.dispose();
    comentarioController.dispose();
  }

  void _mostrarDetalhes(_AvaliacaoLocal avaliacao) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(avaliacao.titulo),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  avaliacao.categoria,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ...List.generate(
                      5,
                          (index) => Icon(
                        index < avaliacao.nota
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('${avaliacao.nota}/5'),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  avaliacao.comentario.isEmpty
                      ? 'Nenhum comentário foi registrado.'
                      : avaliacao.comentario,
                ),
                const SizedBox(height: 16),
                Text(
                  'Data: ${_formatarData(avaliacao.data)}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _removerAvaliacao(_AvaliacaoLocal avaliacao) {
    final indice = _avaliacoes.indexOf(avaliacao);

    if (indice == -1) return;

    setState(() {
      _avaliacoes.removeAt(indice);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Avaliação excluída.'),
        action: SnackBarAction(
          label: 'DESFAZER',
          onPressed: () {
            setState(() {
              _avaliacoes.insert(indice, avaliacao);
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
          _avaliacoes.sort(
                (a, b) => b.data.compareTo(a.data),
          );
          break;
      }
    });
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }
}

class _AvaliacaoLocal {
  final String titulo;
  final String categoria;
  final int nota;
  final String comentario;
  final DateTime data;

  const _AvaliacaoLocal({
    required this.titulo,
    required this.categoria,
    required this.nota,
    required this.comentario,
    required this.data,
  });
}
