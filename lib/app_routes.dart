import 'package:flutter/widgets.dart';
import 'package:marketsapce_app/screens/login-screen.dart';

class AppRoutes {
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';

  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.login: (ctx) => const LoginScreen(),
    AppRoutes.register: (ctx) => const LoginScreen(),
  };
}
