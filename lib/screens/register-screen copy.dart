import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Color(0xffEDECEE),
      extendBody: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.minWidth),
                child: IntrinsicHeight(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
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

                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.gray300,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Icon(PhosphorIconsRegular.user, size: 88),
                      ),

                      Column(
                        children: [
                          Text('Acesse sua conta'),
                          const SizedBox(height: 20),
                          CustomTextField(hintText: 'Nome'),
                          const SizedBox(height: 15),
                          CustomTextField(hintText: 'E-mail'),
                          const SizedBox(height: 15),
                          CustomTextField(hintText: 'Telefone'),
                          const SizedBox(height: 15),
                          CustomTextField(hintText: 'Senha'),
                          const SizedBox(height: 15),
                          CustomTextField(hintText: 'Confirmar Senha'),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton(
                                  onPressed: () {},
                                  child: Text('Entrar'),
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
                                child: FilledButton.tonal(
                                  onPressed: () {},
                                  child: Text('Ir para o login'),
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
            );
          },
        ),
      ),
    );
  }
}
