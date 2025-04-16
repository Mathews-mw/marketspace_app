import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketsapce_app/app_routes.dart';
import 'package:marketsapce_app/components/custom_button.dart';
import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.gray100,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Boas vindas,',
                      style: TextStyle(fontSize: 16, color: AppColors.gray700),
                    ),
                    Text(
                      'Maria!',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.gray700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // CustomButton(
            //   icon: Icon(PhosphorIconsRegular.plus),
            //   label: 'Anunciar',
            //   variant: Variant.secondary,
            //   onPressed: () {
            //     Navigator.of(context).pushNamed(AppRoutes.createAdvertise);
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 30);
}
