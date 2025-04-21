import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:marketsapce_app/app_routes.dart';
import 'package:marketsapce_app/theme/app_colors.dart';
import 'package:marketsapce_app/services/auth_service.dart';
import 'package:marketsapce_app/services/http_service.dart';
import 'package:marketsapce_app/providers/users_provider.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  bool _isAuthenticated = false;
  bool _isRequestCompleted = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      final httpService = HttpService();
      final authService = AuthService();
      final userProvider = Provider.of<UsersProvider>(context, listen: false);

      await userProvider.loadUserData();
      final token = await authService.getToken();

      if (userProvider.user != null && token != null) {
        await httpService.refreshToken();
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
      }
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
      _isAuthenticated = false;
    } finally {
      setState(() {
        _isRequestCompleted = true;
      });

      _redirectUser();
    }
  }

  void _redirectUser() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      _isAuthenticated ? AppRoutes.home : AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight =
        mediaQuery.size.height - mediaQuery.viewPadding.vertical;

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.blueLight,
      body: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenHeight),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/app_logo.png'),
                    Text(
                      'marketspace',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 28,
                        letterSpacing: 0,
                        color: AppColors.gray100,
                      ),
                    ),
                  ],
                ),
              ),
              LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
