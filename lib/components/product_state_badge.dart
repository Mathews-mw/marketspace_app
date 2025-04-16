import 'package:flutter/material.dart';
import 'package:marketsapce_app/theme/app_colors.dart';

class ProductStateBadge extends StatelessWidget {
  final bool isNew;

  const ProductStateBadge({super.key, required this.isNew});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isNew ? AppColors.blueLight : AppColors.gray300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isNew ? 'NOVO' : 'USADO',
        style: TextStyle(
          color: isNew ? Colors.white : AppColors.gray700,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
