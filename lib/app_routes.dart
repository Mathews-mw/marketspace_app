import 'package:flutter/widgets.dart';

import 'package:marketsapce_app/screens/login_screen.dart';
import 'package:marketsapce_app/screens/opening_screen.dart';
import 'package:marketsapce_app/screens/user_ads_screen.dart';
import 'package:marketsapce_app/screens/create_advertise_screen.dart';
import 'package:marketsapce_app/screens/user_product_details_screen.dart';

class AppRoutes {
  static const opening = '/opening';
  static const login = '/login';
  static const home = '/home';
  static const register = '/register';
  static const userAdds = '/user-adds';
  static const userProductDetails = '/user-product-details';
  static const createAdvertise = '/create-advertise';

  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.opening: (ctx) => const OpeningScreen(),
    AppRoutes.login: (ctx) => const LoginScreen(),
    AppRoutes.register: (ctx) => const LoginScreen(),
    AppRoutes.userAdds: (ctx) => const UserAdsScreen(),
    AppRoutes.userProductDetails: (ctx) => const UserProductDetailsScreen(),
    AppRoutes.createAdvertise: (ctx) => const CreateAdVertiseScreen(),
  };
}
