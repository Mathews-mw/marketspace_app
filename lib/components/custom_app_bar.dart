import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/providers/users_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UsersProvider>(context, listen: false).user;

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
                Skeletonizer(
                  enabled: user == null,
                  ignoreContainers: true,
                  effect: ShimmerEffect(
                    baseColor: Colors.black12,
                    highlightColor: AppColors.gray200,
                    duration: Duration(milliseconds: 1500),
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      user!.avatar ??
                          'https://api.dicebear.com/9.x/thumbs/png?seed=${user.name}',
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Skeletonizer(
                  enabled: user == null,
                  effect: ShimmerEffect(
                    baseColor: Colors.black12,
                    highlightColor: AppColors.gray300,
                    duration: Duration(milliseconds: 1500),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Boas vindas,',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.gray700,
                        ),
                      ),
                      Text(
                        user!.name.split(' ').first,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.gray700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 30);
}
