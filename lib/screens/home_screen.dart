
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

  late final List<Widget> _paginas = [
    const _DashboardPage(),
    const DestinosScreen(),
    const RoteiroScreen(),
    const HospedagemScreen(),
    const GastosScreen(),
    const ChecklistScreen(),
    const AvaliacaoScreen(),
  ];

  void _selecionarPagina(int index) {
    setState(() {
      _paginaSelecionada = index;
    });
  }

  // Destinos da navegacao para telas maiores.
  static const List<NavigationRailDestination> _destinosDesktop = [
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: Text('Início'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.place_outlined),
      selectedIcon: Icon(Icons.place),
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
      label: Text('Hospedagem'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.account_balance_wallet_outlined),
      selectedIcon: Icon(Icons.account_balance_wallet),
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
  ];

  // Destinos da navegacao para telas menores.
  static const List<NavigationDestination> _destinosMobile = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Início',
    ),
    NavigationDestination(
      icon: Icon(Icons.place_outlined),
      selectedIcon: Icon(Icons.place),
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
      selectedIcon: Icon(Icons.account_balance_wallet),
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
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  backgroundColor: AppColors.surface,
                  selectedIndex: _paginaSelecionada,
                  onDestinationSelected: _selecionarPagina,
                  labelType: NavigationRailLabelType.all,
                  groupAlignment: -0.8,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Icon(
                      Icons.travel_explore,
                      size: 30,
                      color: AppColors.primary,
                    ),
                  ),
                  destinations: _destinosDesktop,
                ),
                const VerticalDivider(
                  width: 1,
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

        return Scaffold(
          body: IndexedStack(
            index: _paginaSelecionada,
            children: _paginas,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _paginaSelecionada,
            onDestinationSelected: _selecionarPagina,
            destinations: _destinosMobile,
          ),
        );
      },
    );
  }
}

// =====================================================
// TELA INICIAL
// =====================================================

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  void _abrirPagina(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_HomeScreenState>();
    state?._selecionarPagina(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              title: const Row(
                children: [
                  Icon(
                    Icons.travel_explore,
                    color: AppColors.primary,
                    size: 27,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'TRAVEL GO',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    'Planeje sua próxima viagem',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Organize destinos, atividades e despesas '
                        'em um só lugar.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildViagemInicial(context),
                  const SizedBox(height: 32),
                  Text(
                    'Organização da viagem',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Acesse a área que deseja organizar.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAcessos(context),
                  const SizedBox(height: 32),
                  Text(
                    'Por onde começar?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _buildEtapa(
                    numero: '01',
                    titulo: 'Escolha os destinos',
                    descricao:
                    'Adicione os lugares que deseja conhecer.',
                    onTap: () => _abrirPagina(context, 1),
                  ),
                  _buildEtapa(
                    numero: '02',
                    titulo: 'Monte seu roteiro',
                    descricao:
                    'Organize as atividades por dia e horário.',
                    onTap: () => _abrirPagina(context, 2),
                  ),
                  _buildEtapa(
                    numero: '03',
                    titulo: 'Organize os gastos',
                    descricao:
                    'Registre despesas e acompanhe seu orçamento.',
                    onTap: () => _abrirPagina(context, 4),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViagemInicial(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.luggage_outlined,
            color: AppColors.primary,
            size: 30,
          ),
          const SizedBox(height: 18),
          Text(
            'Sua viagem começa aqui',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Comece escolhendo os lugares que deseja visitar. '
                'Depois, organize seu roteiro, hospedagem e orçamento.',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _abrirPagina(context, 1),
            icon: const Icon(Icons.add_location_alt_outlined),
            label: const Text('Explorar destinos'),
          ),
        ],
      ),
    );
  }

  Widget _buildAcessos(BuildContext context) {
    final acessos = [
      _Acesso(
        titulo: 'Destinos',
        descricao: 'Lugares para visitar',
        icone: Icons.place_outlined,
        pagina: 1,
      ),
      _Acesso(
        titulo: 'Roteiro',
        descricao: 'Atividades e horários',
        icone: Icons.route_outlined,
        pagina: 2,
      ),
      _Acesso(
        titulo: 'Hospedagem',
        descricao: 'Hotéis e reservas',
        icone: Icons.hotel_outlined,
        pagina: 3,
      ),
      _Acesso(
        titulo: 'Gastos',
        descricao: 'Despesas e orçamento',
        icone: Icons.account_balance_wallet_outlined,
        pagina: 4,
      ),
      _Acesso(
        titulo: 'Checklist',
        descricao: 'Tarefas da viagem',
        icone: Icons.checklist_outlined,
        pagina: 5,
      ),
      _Acesso(
        titulo: 'Avaliações',
        descricao: 'Notas e comentários',
        icone: Icons.star_outline,
        pagina: 6,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final colunas = constraints.maxWidth >= 800 ? 3 : 2;
        final largura =
            (constraints.maxWidth - (colunas - 1) * 12) / colunas;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: acessos.map((acesso) {
            return SizedBox(
              width: largura,
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _abrirPagina(context, acesso.pagina),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          acesso.icone,
                          color: AppColors.primary,
                          size: 25,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          acesso.titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          acesso.descricao,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEtapa({
    required String numero,
    required String titulo,
    required String descricao,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Text(
          numero,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(descricao),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _Acesso {
  final String titulo;
  final String descricao;
  final IconData icone;
  final int pagina;

  const _Acesso({
    required this.titulo,
    required this.descricao,
    required this.icone,
    required this.pagina,
  });
}
