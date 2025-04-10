import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketsapce_app/theme/app_colors.dart';

enum Variant {
  primary,
  secondary,
  muted;

  Color get color {
    switch (this) {
      case Variant.primary:
        return AppColors.blueLight;
      case Variant.secondary:
        return AppColors.gray700;
      case Variant.muted:
        return AppColors.gray300;
    }
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final Variant? variant;
  final void Function() onPressed;

  const CustomButton({
    super.key,
    required this.label,
    this.variant = Variant.primary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: variant != null ? variant!.color : AppColors.blueLight,
        foregroundColor:
            variant == Variant.muted ? AppColors.gray700 : AppColors.gray100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: GoogleFonts.karla(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: () {},
      child: Text('Entrar'),
    );
  }
}
