import 'package:flutter/material.dart';

import 'package:marketsapce_app/app_routes.dart';
import 'package:marketsapce_app/theme/theme.dart';
import 'package:marketsapce_app/screens/home_screen.dart';
import 'package:marketsapce_app/screens/login_screen.dart';
import 'package:marketsapce_app/screens/register_screen.dart';
import 'package:marketsapce_app/screens/user_ads_screen.dart';
import 'package:marketsapce_app/screens/product_details_screen.dart';
import 'package:marketsapce_app/screens/create_advertise_screen.dart';
import 'package:marketsapce_app/screens/user_product_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Space',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   useMaterial3: true,
      //   textTheme: GoogleFonts.karlaTextTheme(),
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      theme: lightModeTheme,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.login: (ctx) => LoginScreen(),
        AppRoutes.register: (ctx) => RegisterScreen(),
        AppRoutes.home: (ctx) => HomeScreen(),
        AppRoutes.productDetails: (ctx) => ProductDetailsScreen(),
        AppRoutes.userAdds: (ctx) => UserAdsScreen(),
        AppRoutes.userProductDetails: (ctx) => UserProductDetailsScreen(),
        AppRoutes.createAdvertise: (ctx) => CreateAdVertiseScreen(),
      },
    );
  }
}
