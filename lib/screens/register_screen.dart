import 'package:flutter/material.dart';
import 'package:marketsapce_app/app_routes.dart';
import 'package:marketsapce_app/components/custom_button.dart';
import 'package:marketsapce_app/components/password_text_field.dart';
import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:marketsapce_app/components/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight =
        mediaQuery.size.height - mediaQuery.viewPadding.vertical;

    return Scaffold(
      backgroundColor: Color(0xffEDECEE),
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset('assets/images/app_logo.png'),
                    Text(
                      'Boas vindas!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Crie sua conta e use o espaço para comprar itens variados e vender seus produtos',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                Column(
                  children: [
                    CustomTextField(hintText: 'Nome'),
                    const SizedBox(height: 15),
                    CustomTextField(hintText: 'E-mail'),
                    const SizedBox(height: 15),
                    CustomTextField(hintText: 'Telefone'),
                    const SizedBox(height: 15),
                    PasswordTextField(hintText: 'Senha'),
                    const SizedBox(height: 15),
                    PasswordTextField(hintText: 'Confirmar Senha'),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            label: 'Entrar',
                            variant: Variant.secondary,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Column(
                  children: [
                    Text('Já tem uma conta?'),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            label: 'Ir para o login',
                            variant: Variant.muted,
                            onPressed: () {
                              Navigator.of(context).pushNamed(AppRoutes.login);
                            },
                          ),
                        ),
                      ],
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
