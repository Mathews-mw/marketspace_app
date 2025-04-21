import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;

  const PasswordTextField({
    super.key,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.textInputAction,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.validator,
    this.enabled = true,
    this.inputFormatters,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obscurePassword = true;

  onToggleObscurePassword() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      obscureText: obscurePassword,
      obscuringCharacter: '*',
      inputFormatters: widget.inputFormatters,
      style: GoogleFonts.karla(fontSize: 14, color: AppColors.gray700),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 10, left: 20),
        constraints: BoxConstraints(
          // maxHeight: height * 0.065,
          // maxWidth: width * 0.065,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: widget.hintText,
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.gray400),
        errorStyle: GoogleFonts.inter(fontSize: 12, color: Colors.redAccent),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword
                ? PhosphorIconsRegular.eye
                : PhosphorIconsRegular.eyeSlash,
          ),
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.gray700, width: 1),
        ),
      ),
    );
  }
}
