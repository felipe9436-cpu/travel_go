import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class HospedagemScreen extends StatefulWidget {
  const HospedagemScreen({super.key});

  @override
  State<HospedagemScreen> createState() => _HospedagemScreenState();
}

class _HospedagemScreenState extends State<HospedagemScreen> {
  final List<_Hospedagem> _hospedagens = [
    const _Hospedagem(
      nome: 'Hotel Le Central',
      cidade: 'Paris, França',
      endereco: '15 Rue de Rivoli',
      checkIn: '12 Dez',
      checkOut: '20 Dez',
      noites: 8,
      valor: 'R\$ 3.240',
      nota: 4.8,
      icon: Icons.hotel_rounded,
    ),
    const _Hospedagem(
      nome: 'Maison de Paris',
      cidade: 'Paris, França',
      endereco: '28 Rue Saint-Honoré',
      checkIn: '20 Dez',
      checkOut: '22 Dez',
      noites: 2,
      valor: 'R\$ 890',
      nota: 4.6,
      icon: Icons.apartment_rounded,
    ),
  ];

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
                'Hospedagem',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              actions: [
                IconButton.filledTonal(
                  tooltip: 'Pesquisar',
                  onPressed: _pesquisar,
                  icon: const Icon(Icons.search),
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
                  _buildSummary(),
                  const SizedBox(height: 28),
                  _buildSectionTitle(),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
            _buildHospedagens(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                28,
                20,
                100,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildBookingTip(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirAdicionarHospedagem,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar hospedagem'),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Onde você vai ficar?',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 7),
        const Text(
          'Organize suas reservas e tenha todos os detalhes da hospedagem em um só lugar.',
          style: TextStyle(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.hotel_rounded,
                    color: AppColors.primary,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sua hospedagem',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '2 reservas • 10 noites',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.verified_outlined,
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Divider(
              color: AppColors.border,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.nights_stay_outlined,
                    value: '10',
                    label: 'Noites',
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.hotel_outlined,
                    value: '2',
                    label: 'Reservas',
                  ),
                ),
                const Expanded(
                  child: _SummaryItem(
                    icon: Icons.payments_outlined,
                    value: 'R\$ 4.130',
                    label: 'Total',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Minhas reservas',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Suas hospedagens durante a viagem',
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
          onSelected: (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ordenação: $value'),
              ),
            );
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'Entrada',
              child: Text('Por check-in'),
            ),
            PopupMenuItem(
              value: 'Valor',
              child: Text('Por valor'),
            ),
            PopupMenuItem(
              value: 'Nota',
              child: Text('Por avaliação'),
            ),
          ],
          icon: const Icon(Icons.sort),
        ),
      ],
    );
  }

  Widget _buildHospedagens() {
    if (_hospedagens.isEmpty) {
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
            final hospedagem = _hospedagens[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _HospedagemCard(
                hospedagem: hospedagem,
                onTap: () => _abrirDetalhes(hospedagem),
                onDelete: () => _removerHospedagem(index),
              ),
            );
          },
          childCount: _hospedagens.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hotel_outlined,
                color: AppColors.primary,
                size: 34,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Nenhuma hospedagem',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Adicione sua primeira hospedagem para organizar sua viagem.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _abrirAdicionarHospedagem,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar hospedagem'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingTip() {
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
                color: AppColors.blue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.info_outline,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Guarde endereço, horário de check-in e informações da reserva para encontrar tudo rapidamente durante a viagem.',
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

  void _abrirAdicionarHospedagem() {
    final nomeController = TextEditingController();
    final cidadeController = TextEditingController();
    final enderecoController = TextEditingController();
    final valorController = TextEditingController();

    DateTime? checkIn;
    DateTime? checkOut;

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
                      'Nova hospedagem',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Cadastre os detalhes da sua reserva.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: nomeController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nome da hospedagem',
                        hintText: 'Ex.: Hotel Le Central',
                        prefixIcon: Icon(Icons.hotel_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: cidadeController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Cidade / País',
                        hintText: 'Ex.: Paris, França',
                        prefixIcon: Icon(Icons.public),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: enderecoController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Endereço',
                        hintText: 'Ex.: Rue de Rivoli, 15',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: valorController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Valor da reserva',
                        hintText: 'Ex.: 1500,00',
                        prefixIcon: Icon(Icons.payments_outlined),
                        prefixText: 'R\$ ',
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final data = await _selecionarData(
                                context,
                                checkIn,
                              );

                              if (data != null) {
                                setModalState(() {
                                  checkIn = data;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.login_outlined,
                            ),
                            label: Text(
                              checkIn == null
                                  ? 'Check-in'
                                  : _formatarData(checkIn!),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final data = await _selecionarData(
                                context,
                                checkOut,
                              );

                              if (data != null) {
                                setModalState(() {
                                  checkOut = data;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.logout_outlined,
                            ),
                            label: Text(
                              checkOut == null
                                  ? 'Check-out'
                                  : _formatarData(checkOut!),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          if (nomeController.text.trim().isEmpty ||
                              cidadeController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Preencha pelo menos nome e cidade.',
                                ),
                              ),
                            );
                            return;
                          }

                          final novaHospedagem = _Hospedagem(
                            nome: nomeController.text.trim(),
                            cidade: cidadeController.text.trim(),
                            endereco: enderecoController.text.trim().isEmpty
                                ? 'Endereço não informado'
                                : enderecoController.text.trim(),
                            checkIn: checkIn == null
                                ? 'A definir'
                                : _formatarData(checkIn!),
                            checkOut: checkOut == null
                                ? 'A definir'
                                : _formatarData(checkOut!),
                            noites: _calcularNoites(
                              checkIn,
                              checkOut,
                            ),
                            valor: valorController.text.trim().isEmpty
                                ? 'Não informado'
                                : 'R\$ ${valorController.text.trim()}',
                            nota: 0,
                            icon: Icons.hotel_rounded,
                          );

                          setState(() {
                            _hospedagens.add(novaHospedagem);
                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Hospedagem adicionada à viagem.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar hospedagem'),
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

  Future<DateTime?> _selecionarData(
      BuildContext context,
      DateTime? inicial,
      ) {
    return showDatePicker(
      context: context,
      initialDate: inicial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
  }

  int _calcularNoites(
      DateTime? inicio,
      DateTime? fim,
      ) {
    if (inicio == null || fim == null) {
      return 0;
    }

    final diferenca = fim.difference(inicio).inDays;

    return diferenca < 0 ? 0 : diferenca;
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

  void _abrirDetalhes(_Hospedagem hospedagem) {
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
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: const Icon(
                        Icons.hotel_rounded,
                        color: AppColors.primary,
                        size: 29,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hospedagem.nome,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hospedagem.cidade,
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
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  title: 'Endereço',
                  value: hospedagem.endereco,
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.login_outlined,
                  title: 'Check-in',
                  value: hospedagem.checkIn,
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.logout_outlined,
                  title: 'Check-out',
                  value: hospedagem.checkOut,
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.nights_stay_outlined,
                  title: 'Noites',
                  value: hospedagem.noites == 0
                      ? 'Não informado'
                      : '${hospedagem.noites} noites',
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
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'O mapa será integrado futuramente.',
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

  void _removerHospedagem(int index) {
    final hospedagem = _hospedagens[index];

    setState(() {
      _hospedagens.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${hospedagem.nome} removido.',
        ),
        action: SnackBarAction(
          label: 'DESFAZER',
          onPressed: () {
            setState(() {
              _hospedagens.insert(index, hospedagem);
            });
          },
        ),
      ),
    );
  }

  void _pesquisar() {
    showSearch(
      context: context,
      delegate: _HospedagemSearchDelegate(_hospedagens),
    );
  }
}

class _Hospedagem {
  final String nome;
  final String cidade;
  final String endereco;
  final String checkIn;
  final String checkOut;
  final int noites;
  final String valor;
  final double nota;
  final IconData icon;

  const _Hospedagem({
    required this.nome,
    required this.cidade,
    required this.endereco,
    required this.checkIn,
    required this.checkOut,
    required this.noites,
    required this.valor,
    required this.nota,
    required this.icon,
  });
}

class _HospedagemCard extends StatelessWidget {
  final _Hospedagem hospedagem;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _HospedagemCard({
    required this.hospedagem,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(
        '${hospedagem.nome}_${hospedagem.endereco}',
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
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: const Icon(
                        Icons.hotel_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hospedagem.nome,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
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
                                  hospedagem.cidade,
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
                    if (hospedagem.nota > 0)
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.warning,
                            size: 18,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            hospedagem.nota.toStringAsFixed(1),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.login_outlined,
                        label: 'Check-in',
                        value: hospedagem.checkIn,
                      ),
                    ),
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.logout_outlined,
                        label: 'Check-out',
                        value: hospedagem.checkOut,
                      ),
                    ),
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.payments_outlined,
                        label: 'Valor',
                        value: hospedagem.valor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.textMuted,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        hospedagem.endereco,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
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
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 19,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ],
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
            fontWeight: FontWeight.w900,
            fontSize: 17,
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

class _HospedagemSearchDelegate
    extends SearchDelegate<_Hospedagem?> {
  final List<_Hospedagem> hospedagens;

  _HospedagemSearchDelegate(this.hospedagens);

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
    final resultados = hospedagens.where((hospedagem) {
      final termo = query.toLowerCase();

      return hospedagem.nome.toLowerCase().contains(termo) ||
          hospedagem.cidade.toLowerCase().contains(termo) ||
          hospedagem.endereco.toLowerCase().contains(termo);
    }).toList();

    if (resultados.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma hospedagem encontrada.',
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
        final hospedagem = resultados[index];

        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          tileColor: AppColors.surface,
          leading: const CircleAvatar(
            backgroundColor: Color(0x1FD6A84F),
            child: Icon(
              Icons.hotel_outlined,
              color: AppColors.primary,
            ),
          ),
          title: Text(hospedagem.nome),
          subtitle: Text(hospedagem.cidade),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => close(context, hospedagem),
        );
      },
    );
  }
}