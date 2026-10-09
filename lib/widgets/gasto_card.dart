import 'package:flutter/material.dart';

import '../models/gasto.dart';
import '../theme/app_colors.dart';

class GastoCard extends StatelessWidget {
  final Gasto gasto;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const GastoCard({
    super.key,
    required this.gasto,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cor = _corCategoria(gasto.categoria);
    final icone = _iconeCategoria(gasto.categoria);

    return Dismissible(
      key: ValueKey(gasto.id),
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
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: cor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icone, color: cor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gasto.descricao,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            gasto.categoria,
                            style: TextStyle(
                              color: cor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '•',
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                          ),
                          Text(
                            '${gasto.data.day}/${gasto.data.month}',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ${gasto.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textMuted,
                      size: 18,
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

  IconData _iconeCategoria(String categoria) {
    switch (categoria) {
      case 'Hospedagem':
        return Icons.hotel_outlined;
      case 'Alimentação':
        return Icons.restaurant_outlined;
      case 'Passeio':
        return Icons.local_activity_outlined;
      case 'Transporte':
        return Icons.directions_car_outlined;
      case 'Compras':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  Color _corCategoria(String categoria) {
    switch (categoria) {
      case 'Hospedagem':
        return AppColors.blue;
      case 'Alimentação':
        return AppColors.success;
      case 'Passeio':
        return AppColors.primary;
      case 'Transporte':
        return const Color(0xFF8B5CF6);
      case 'Compras':
        return AppColors.cyan;
      default:
        return AppColors.textSecondary;
    }
  }
}