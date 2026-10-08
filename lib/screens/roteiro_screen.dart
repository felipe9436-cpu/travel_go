import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RoteiroScreen extends StatefulWidget {
  const RoteiroScreen({super.key});

  @override
  State<RoteiroScreen> createState() => _RoteiroScreenState();
}

class _RoteiroScreenState extends State<RoteiroScreen> {
  int _selectedDay = 1;

  final List<_DiaViagem> _dias = const [
    _DiaViagem(
      numero: 1,
      data: '12 DEZ',
      semana: 'QUI',
    ),
    _DiaViagem(
      numero: 2,
      data: '13 DEZ',
      semana: 'SEX',
    ),
    _DiaViagem(
      numero: 3,
      data: '14 DEZ',
      semana: 'SÁB',
    ),
    _DiaViagem(
      numero: 4,
      data: '15 DEZ',
      semana: 'DOM',
    ),
    _DiaViagem(
      numero: 5,
      data: '16 DEZ',
      semana: 'SEG',
    ),
    _DiaViagem(
      numero: 6,
      data: '17 DEZ',
      semana: 'TER',
    ),
    _DiaViagem(
      numero: 7,
      data: '18 DEZ',
      semana: 'QUA',
    ),
    _DiaViagem(
      numero: 8,
      data: '19 DEZ',
      semana: 'QUI',
    ),
  ];

  final Map<int, List<_Atividade>> _atividades = {
    1: const [
      _Atividade(
        horario: '09:00',
        titulo: 'Café da manhã',
        local: 'Hotel Le Central',
        categoria: 'Alimentação',
        icon: Icons.restaurant_outlined,
        cor: AppColors.success,
      ),
      _Atividade(
        horario: '11:30',
        titulo: 'Museu do Louvre',
        local: 'Rue de Rivoli',
        categoria: 'Cultura',
        icon: Icons.museum_outlined,
        cor: AppColors.primary,
      ),
      _Atividade(
        horario: '15:30',
        titulo: 'Jardim das Tulherias',
        local: 'Place de la Concorde',
        categoria: 'Passeio',
        icon: Icons.park_outlined,
        cor: AppColors.success,
      ),
      _Atividade(
        horario: '19:00',
        titulo: 'Jantar',
        local: 'Le Petit Restaurant',
        categoria: 'Restaurante',
        icon: Icons.dinner_dining_outlined,
        cor: AppColors.warning,
      ),
    ],
    2: const [
      _Atividade(
        horario: '09:30',
        titulo: 'Torre Eiffel',
        local: 'Champ de Mars',
        categoria: 'Ponto turístico',
        icon: Icons.location_city,
        cor: AppColors.blue,
      ),
      _Atividade(
        horario: '13:00',
        titulo: 'Almoço',
        local: 'Café de Paris',
        categoria: 'Alimentação',
        icon: Icons.restaurant_outlined,
        cor: AppColors.success,
      ),
      _Atividade(
        horario: '16:00',
        titulo: 'Arco do Triunfo',
        local: 'Place Charles de Gaulle',
        categoria: 'Passeio',
        icon: Icons.account_balance_outlined,
        cor: AppColors.primary,
      ),
    ],
    3: const [
      _Atividade(
        horario: '10:00',
        titulo: 'Montmartre',
        local: '18º arrondissement',
        categoria: 'Passeio',
        icon: Icons.photo_camera_outlined,
        cor: Color(0xFF8B5CF6),
      ),
      _Atividade(
        horario: '12:30',
        titulo: 'Almoço em Montmartre',
        local: 'Rue des Abbesses',
        categoria: 'Restaurante',
        icon: Icons.restaurant_outlined,
        cor: AppColors.warning,
      ),
    ],
  };

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
                'Roteiro',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              actions: [
                IconButton.filledTonal(
                  tooltip: 'Opções',
                  onPressed: _mostrarOpcoes,
                  icon: const Icon(Icons.more_horiz),
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
                  _buildTripProgress(),
                  const SizedBox(height: 28),
                  _buildDaySelector(),
                  const SizedBox(height: 28),
                  _buildDayHeader(),
                  const SizedBox(height: 18),
                  _buildTimeline(),
                  const SizedBox(height: 30),
                  _buildDaySummary(),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirAdicionarAtividade,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar atividade'),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Planeje seus dias',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 7),
              const Text(
                'Organize atividades, horários e lugares em uma linha do tempo.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        IconButton.filledTonal(
          tooltip: 'Compartilhar roteiro',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Compartilhamento do roteiro estará disponível em breve.',
                ),
              ),
            );
          },
          icon: const Icon(Icons.ios_share_outlined),
        ),
      ],
    );
  }

  Widget _buildTripProgress() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.route_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Planejamento da viagem',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '12 de 20 atividades planejadas',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  '60%',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const LinearProgressIndicator(
                value: 0.6,
                minHeight: 8,
                backgroundColor: AppColors.border,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dias da viagem',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _dias.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final dia = _dias[index];
              final selected = _selectedDay == dia.numero;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = dia.numero;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 78,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dia.semana,
                        style: TextStyle(
                          color: selected
                              ? Colors.black
                              : AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${dia.numero}',
                        style: TextStyle(
                          color: selected
                              ? Colors.black
                              : AppColors.textPrimary,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dia.data,
                        style: TextStyle(
                          color: selected
                              ? Colors.black.withValues(alpha: 0.7)
                              : AppColors.textSecondary,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayHeader() {
    final atividadesDoDia = _atividades[_selectedDay] ?? [];

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dia $_selectedDay',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '${atividadesDoDia.length} atividades planejadas',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'Ordenar',
          icon: const Icon(Icons.sort),
          onSelected: (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ordenação: $value'),
              ),
            );
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'Horário',
              child: Text('Por horário'),
            ),
            PopupMenuItem(
              value: 'Categoria',
              child: Text('Por categoria'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    final atividadesDoDia = _atividades[_selectedDay] ?? [];

    if (atividadesDoDia.isEmpty) {
      return _buildEmptyDay();
    }

    return Column(
      children: List.generate(
        atividadesDoDia.length,
            (index) {
          final atividade = atividadesDoDia[index];
          final isLast = index == atividadesDoDia.length - 1;

          return _TimelineActivity(
            atividade: atividade,
            isLast: isLast,
            onTap: () => _abrirDetalhesAtividade(atividade),
          );
        },
      ),
    );
  }

  Widget _buildEmptyDay() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_available_outlined,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Dia livre',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Você ainda não adicionou atividades para este dia.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _abrirAdicionarAtividade,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar atividade'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySummary() {
    final atividadesDoDia = _atividades[_selectedDay] ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo do dia',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.event_note_outlined,
                    value: '${atividadesDoDia.length}',
                    label: 'Atividades',
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.schedule_outlined,
                    value: '8h',
                    label: 'Planejado',
                  ),
                ),
                const Expanded(
                  child: _SummaryItem(
                    icon: Icons.location_on_outlined,
                    value: '4',
                    label: 'Locais',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _abrirAdicionarAtividade() {
    final tituloController = TextEditingController();
    final localController = TextEditingController();

    TimeOfDay horarioSelecionado = const TimeOfDay(
      hour: 10,
      minute: 0,
    );

    String categoriaSelecionada = 'Passeio';

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
                      'Nova atividade',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Adicione uma atividade ao seu roteiro.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: tituloController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Atividade',
                        hintText: 'Ex.: Visitar Torre Eiffel',
                        prefixIcon: Icon(Icons.event_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: localController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Local',
                        hintText: 'Ex.: Champ de Mars',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Horário',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final horario = await showTimePicker(
                            context: context,
                            initialTime: horarioSelecionado,
                          );

                          if (horario != null) {
                            setModalState(() {
                              horarioSelecionado = horario;
                            });
                          }
                        },
                        icon: const Icon(Icons.schedule_outlined),
                        label: Text(
                          horarioSelecionado.format(context),
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
                        for (final categoria in [
                          'Passeio',
                          'Cultura',
                          'Alimentação',
                          'Compras',
                          'Transporte',
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
                          if (tituloController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Digite o nome da atividade.',
                                ),
                              ),
                            );
                            return;
                          }

                          final novaAtividade = _Atividade(
                            horario: horarioSelecionado.format(context),
                            titulo: tituloController.text.trim(),
                            local: localController.text.trim().isEmpty
                                ? 'Local não informado'
                                : localController.text.trim(),
                            categoria: categoriaSelecionada,
                            icon: _iconeCategoria(
                              categoriaSelecionada,
                            ),
                            cor: _corCategoria(
                              categoriaSelecionada,
                            ),
                          );

                          setState(() {
                            _atividades[_selectedDay] = [
                              ...?_atividades[_selectedDay],
                              novaAtividade,
                            ];
                          });

                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar ao roteiro'),
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

  void _abrirDetalhesAtividade(_Atividade atividade) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
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
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: atividade.cor.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Icon(
                        atividade.icon,
                        color: atividade.cor,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            atividade.titulo,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            atividade.categoria,
                            style: TextStyle(
                              color: atividade.cor,
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
                  icon: Icons.schedule_outlined,
                  title: 'Horário',
                  value: atividade.horario,
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  title: 'Local',
                  value: atividade.local,
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
                              content: Text(
                                'Edição estará disponível em breve.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Editar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Mapa estará disponível em breve.',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.map_outlined),
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

  void _mostrarOpcoes() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Opções do roteiro',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text('Alterar período'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.auto_awesome_outlined),
                title: const Text('Otimizar roteiro'),
                subtitle: const Text('Reorganizar atividades por proximidade'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Otimização automática será adicionada futuramente.',
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Limpar roteiro'),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  IconData _iconeCategoria(String categoria) {
    switch (categoria) {
      case 'Cultura':
        return Icons.museum_outlined;
      case 'Alimentação':
        return Icons.restaurant_outlined;
      case 'Compras':
        return Icons.shopping_bag_outlined;
      case 'Transporte':
        return Icons.directions_car_outlined;
      default:
        return Icons.explore_outlined;
    }
  }

  Color _corCategoria(String categoria) {
    switch (categoria) {
      case 'Cultura':
        return AppColors.primary;
      case 'Alimentação':
        return AppColors.success;
      case 'Compras':
        return const Color(0xFF8B5CF6);
      case 'Transporte':
        return AppColors.blue;
      default:
        return AppColors.cyan;
    }
  }
}

class _DiaViagem {
  final int numero;
  final String data;
  final String semana;

  const _DiaViagem({
    required this.numero,
    required this.data,
    required this.semana,
  });
}

class _Atividade {
  final String horario;
  final String titulo;
  final String local;
  final String categoria;
  final IconData icon;
  final Color cor;

  const _Atividade({
    required this.horario,
    required this.titulo,
    required this.local,
    required this.categoria,
    required this.icon,
    required this.cor,
  });
}

class _TimelineActivity extends StatelessWidget {
  final _Atividade atividade;
  final bool isLast;
  final VoidCallback onTap;

  const _TimelineActivity({
    required this.atividade,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 58,
            child: Column(
              children: [
                Text(
                  atividade.horario,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : AppColors.border,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: atividade.cor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: atividade.cor.withValues(alpha: 0.25),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(17),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: atividade.cor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            atividade.icon,
                            color: atividade.cor,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                atividade.categoria.toUpperCase(),
                                style: TextStyle(
                                  color: atividade.cor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                atividade.titulo,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      atividade.local,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 21,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
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
        Column(
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
      ],
    );
  }
}