import 'package:flutter/material.dart';
import 'package:marketsapce_app/components/error_alert_dialog.dart';
import 'package:provider/provider.dart';

import 'package:marketsapce_app/app_routes.dart';
import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/services/auth_service.dart';
import 'package:marketsapce_app/services/http_service.dart';
import 'package:marketsapce_app/providers/users_provider.dart';
import 'package:marketsapce_app/components/custom_button.dart';
import 'package:marketsapce_app/components/loading_overlay.dart';
import 'package:marketsapce_app/@exceptions/api_exceptions.dart';
import 'package:marketsapce_app/components/custom_text_field.dart';
import 'package:marketsapce_app/@mixins/form_validations_mixin.dart';
import 'package:marketsapce_app/components/password_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with FormValidationsMixin {
  bool obscurePassword = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, Object> formData = <String, Object>{};

  bool _isLoading = false;

  Future<void> handleLogin() async {
    setState(() => _isLoading = true);

    final bool isValidForm = formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      print('Invalid form!');
      return;
    }

    formKey.currentState?.save();

    try {
      final httpService = HttpService();
      final authService = AuthService();

      final response = await httpService.post('auth/credentials', {
        'email': formData['email'],
        'password': formData['password'],
      });

      print('login response: ${response}');

      authService.saveToken(response['token']);

      if (context.mounted) {
        await Provider.of<UsersProvider>(context, listen: false).loadUserData();

        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } on ApiExceptions catch (error) {
      print('Login error: ${error}');

      if (context.mounted) {
        ErrorAlertDialog.showDialogError(
          context: context,
          title: 'Erro de autenticação',
          code: error.code,
          message: error.message,
          description:
              'Credenciais inválidas! Por favor, verifique seu e-mail e senha e tente novamente.',
        );
      }
    } catch (error) {
      print('Unexpected Login error: ${error}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aconteceu um erro inesperado. Tente novamente'),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    formData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight =
        mediaQuery.size.height - mediaQuery.viewPadding.vertical;

    return Scaffold(
      backgroundColor: AppColors.gray100,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 48,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset('assets/images/app_logo.png'),
                        Text(
                          'marketspace',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontSize: 32, letterSpacing: 0),
                        ),
                        Text(
                          'Seu espaço de compra e venda',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: AppColors.gray500,
                          ),
                        ),
                      ],
                    ),

                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Text('Acesse sua conta'),
                          const SizedBox(height: 20),
                          CustomTextField(
                            hintText: 'E-mail',
                            enabled: !_isLoading,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator:
                                (value) => combine([
                                  () => isNotEmpty(value),
                                  () => isEmail(
                                    value,
                                    'Por favor, informe um e-mail válido.',
                                  ),
                                ]),
                            onSaved: (value) {
                              formData['email'] = value ?? '';
                            },
                          ),
                          const SizedBox(height: 20),
                          PasswordTextField(
                            hintText: 'Senha',
                            enabled: !_isLoading,
                            validator: isNotEmpty,
                            onSaved: (value) {
                              formData['password'] = value ?? '';
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  label: 'Entrar',
                                  onPressed: () => handleLogin(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Column(
                      children: [
                        Text('Ainda não tem acesso?'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                label: 'Criar uma conta',
                                variant: Variant.muted,
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(AppRoutes.register);
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
          if (_isLoading) LoadingOverlay(message: 'Autenticando...'),
        ],
      ),
    );
  }
}
