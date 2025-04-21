import 'package:flutter/material.dart';
import 'package:marketsapce_app/theme/app_colors.dart';

class LoadingFullscreen extends StatelessWidget {
  const LoadingFullscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.blueLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator(color: Colors.white)],
        ),
      ),
    );
  }
}
