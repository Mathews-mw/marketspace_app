import 'package:flutter/material.dart';
import 'package:marketsapce_app/app_routes.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:marketsapce_app/theme/app_colors.dart';

class TopCard extends StatelessWidget {
  const TopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(PhosphorIconsBold.tag, color: AppColors.blueLight),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '4',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text('Anúncios Ativos', style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.userAdds);
            },
            label: Text(
              'Meus anúncios',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.blue,
              ),
            ),
            icon: Icon(PhosphorIconsBold.arrowRight, color: AppColors.blue),
            iconAlignment: IconAlignment.end,
          ),
        ],
      ),
    );
  }
}
