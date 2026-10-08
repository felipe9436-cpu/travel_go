import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'avaliacao_screen.dart';
import 'checklist_screen.dart';
import 'destinos_screen.dart';
import 'gastos_screen.dart';
import 'hospedagem_screen.dart';
import 'roteiro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _paginaSelecionada = 0;

  late final List<Widget> _paginas;

  @override
  void initState() {
    super.initState();

    _paginas = [
      const _DashboardPage(),
      const DestinosScreen(),
      const RoteiroScreen(),
      const HospedagemScreen(),
      const GastosScreen(),
      const ChecklistScreen(),
      const AvaliacaoScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        if (isDesktop) {
          return _buildDesktopLayout();
        }

        return _buildMobileLayout();
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          _buildNavigationRail(),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: AppColors.border,
          ),
          Expanded(
            child: IndexedStack(
              index: _paginaSelecionada,
              children: _paginas,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: IndexedStack(
        index: _paginaSelecionada,
        children: _paginas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _paginaSelecionada,
        onDestinationSelected: _selecionarPagina,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on),
            label: 'Destinos',
          ),
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: 'Roteiro',
          ),
          NavigationDestination(
            icon: Icon(Icons.hotel_outlined),
            selectedIcon: Icon(Icons.hotel),
            label: 'Hospedagem',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon:
            Icon(Icons.account_balance_wallet),
            label: 'Gastos',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Checklist',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star),
            label: 'Avaliações',
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail() {
    return Container(
      width: 92,
      color: AppColors.surface,
      child: NavigationRail(
        selectedIndex: _paginaSelecionada,
        onDestinationSelected: _selecionarPagina,
        labelType: NavigationRailLabelType.all,
        groupAlignment: -0.85,
        leading: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 28,
          ),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.travel_explore,
              color: Colors.black,
              size: 26,
            ),
          ),
        ),
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: Text('Início'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on),
            label: Text('Destinos'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: Text('Roteiro'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.hotel_outlined),
            selectedIcon: Icon(Icons.hotel),
            label: Text('Hotel'),
          ),
          NavigationRailDestination(
            icon: Icon(
              Icons.account_balance_wallet_outlined,
            ),
            selectedIcon: Icon(
              Icons.account_balance_wallet,
            ),
            label: Text('Gastos'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: Text('Checklist'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star),
            label: Text('Avaliações'),
          ),
        ],
      ),
    );
  }

  void _selecionarPagina(int index) {
    setState(() {
      _paginaSelecionada = index;
    });
  }
}

///
/// DASHBOARD
///

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              pinned: true,
              title: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.travel_explore,
                      color: Colors.black,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'TRAVEL GO',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton.filledTonal(
                  tooltip: 'Notificações',
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Nenhuma notificação nova.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications_none,
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                40,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildGreeting(context),
                  const SizedBox(height: 24),
                  _buildTripCard(),
                  const SizedBox(height: 28),
                  _buildSectionTitle(
                    'Acesso rápido',
                    'Organize sua viagem',
                  ),
                  const SizedBox(height: 14),
                  _buildQuickActions(context),
                  const SizedBox(height: 28),
                  _buildSectionTitle(
                    'Visão geral',
                    'Resumo da sua viagem',
                  ),
                  const SizedBox(height: 14),
                  _buildOverview(),
                  const SizedBox(height: 28),
                  _buildUpcoming(),
                  const SizedBox(height: 28),
                  _buildChecklistPreview(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Olá, viajante 👋',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Sua próxima aventura',
          style: Theme.of(context)
              .textTheme
              .headlineMedium,
        ),
      ],
    );
  }

  Widget _buildTripCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary
                        .withValues(alpha: 0.14),
                    borderRadius:
                    BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flight_takeoff,
                        color: AppColors.primary,
                        size: 15,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'PRÓXIMA VIAGEM',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Paris, França',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '12 — 18 Dezembro 2026',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                _TripInfo(
                  icon: Icons.calendar_today_outlined,
                  value: '7 dias',
                ),
                const SizedBox(width: 12),
                _TripInfo(
                  icon: Icons.place_outlined,
                  value: '8 lugares',
                ),
                const SizedBox(width: 12),
                _TripInfo(
                  icon: Icons.people_outline,
                  value: '2 pessoas',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
      String title,
      String subtitle,
      ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(
        title: 'Destinos',
        subtitle: 'Lugares',
        icon: Icons.location_on_outlined,
        color: AppColors.primary,
        page: 1,
      ),
      _QuickAction(
        title: 'Roteiro',
        subtitle: 'Planejar',
        icon: Icons.route_outlined,
        color: AppColors.blue,
        page: 2,
      ),
      _QuickAction(
        title: 'Hospedagem',
        subtitle: 'Reservas',
        icon: Icons.hotel_outlined,
        color: AppColors.cyan,
        page: 3,
      ),
      _QuickAction(
        title: 'Gastos',
        subtitle: 'Finanças',
        icon: Icons.account_balance_wallet_outlined,
        color: AppColors.success,
        page: 4,
      ),
      _QuickAction(
        title: 'Checklist',
        subtitle: 'Preparar',
        icon: Icons.checklist_outlined,
        color: const Color(0xFF8B5CF6),
        page: 5,
      ),
      _QuickAction(
        title: 'Avaliações',
        subtitle: 'Experiências',
        icon: Icons.star_outline,
        color: AppColors.warning,
        page: 6,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = constraints.maxWidth;

        int colunas = 2;

        if (largura >= 800) {
          colunas = 3;
        }

        if (largura >= 1100) {
          colunas = 6;
        }

        final larguraCard =
            (largura - ((colunas - 1) * 10)) /
                colunas;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: actions.map((action) {
            return SizedBox(
              width: larguraCard,
              child: _QuickActionCard(
                action: action,
                onTap: () {
                  final state = context
                      .findAncestorStateOfType<
                      _HomeScreenState>();

                  state?._selecionarPagina(
                    action.page,
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildOverview() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;

        final cards = [
          const _OverviewItem(
            icon: Icons.location_on_outlined,
            title: 'Destinos',
            value: '8',
            subtitle: 'lugares salvos',
            color: AppColors.primary,
          ),
          const _OverviewItem(
            icon: Icons.route_outlined,
            title: 'Atividades',
            value: '14',
            subtitle: 'no roteiro',
            color: AppColors.blue,
          ),
          const _OverviewItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Gastos',
            value: 'R\$ 3.662',
            subtitle: 'de R\$ 6.000',
            color: AppColors.success,
          ),
          const _OverviewItem(
            icon: Icons.checklist_outlined,
            title: 'Checklist',
            value: '3/8',
            subtitle: 'concluídos',
            color: Color(0xFF8B5CF6),
          ),
        ];

        return GridView.builder(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 4 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: isWide ? 1.45 : 1.3,
          ),
          itemBuilder: (context, index) {
            return _OverviewCard(
              item: cards[index],
            );
          },
        );
      },
    );
  }

  Widget _buildUpcoming() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Próximas atividades',
          'O que está programado',
        ),
        const SizedBox(height: 14),
        const _ActivityCard(
          time: '09:00',
          title: 'Visita à Torre Eiffel',
          subtitle: 'Champ de Mars',
          icon: Icons.location_on_outlined,
          color: AppColors.primary,
        ),
        const SizedBox(height: 10),
        const _ActivityCard(
          time: '13:30',
          title: 'Almoço no Le Petit Café',
          subtitle: '7º arrondissement',
          icon: Icons.restaurant_outlined,
          color: AppColors.success,
        ),
        const SizedBox(height: 10),
        const _ActivityCard(
          time: '15:00',
          title: 'Museu do Louvre',
          subtitle: 'Rue de Rivoli',
          icon: Icons.museum_outlined,
          color: AppColors.blue,
        ),
      ],
    );
  }

  Widget _buildChecklistPreview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Checklist',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Prepare tudo antes da viagem',
                        style: TextStyle(
                          color:
                          AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  '3/8',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 17),
            ClipRRect(
              borderRadius:
              BorderRadius.circular(20),
              child: const LinearProgressIndicator(
                value: 0.375,
                minHeight: 7,
                backgroundColor:
                AppColors.border,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14),
            const _ChecklistPreviewItem(
              title: 'Passaporte',
              completed: true,
            ),
            const _ChecklistPreviewItem(
              title: 'Seguro viagem',
              completed: true,
            ),
            const _ChecklistPreviewItem(
              title: 'Reserva do hotel',
              completed: true,
            ),
            const _ChecklistPreviewItem(
              title: 'Separar roupas',
              completed: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _TripInfo extends StatelessWidget {
  final IconData icon;
  final String value;

  const _TripInfo({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(
            alpha: 0.16,
          ),
          borderRadius:
          BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int page;

  const _QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.page,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: action.color.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: Icon(
                  action.icon,
                  color: action.color,
                  size: 21,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                action.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                action.subtitle,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewItem {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _OverviewItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });
}

class _OverviewCard extends StatelessWidget {
  final _OverviewItem item;

  const _OverviewCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Icon(
              item.icon,
              color: item.color,
              size: 21,
            ),
            const Spacer(),
            Text(
              item.title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.subtitle,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ActivityCard({
    required this.time,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              child: Text(
                time,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: color.withValues(
                  alpha: 0.12,
                ),
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
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
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
      ),
    );
  }
}

class _ChecklistPreviewItem
    extends StatelessWidget {
  final String title;
  final bool completed;

  const _ChecklistPreviewItem({
    required this.title,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(
            completed
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: completed
                ? AppColors.success
                : AppColors.textMuted,
            size: 21,
          ),
          const SizedBox(width: 11),
          Text(
            title,
            style: TextStyle(
              color: completed
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              decoration: completed
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}