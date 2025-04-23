import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'package:marketsapce_app/app_routes.dart';
import 'package:marketsapce_app/theme/theme.dart';
import 'package:marketsapce_app/screens/home_screen.dart';
import 'package:marketsapce_app/screens/login_screen.dart';
import 'package:marketsapce_app/screens/opening_screen.dart';
import 'package:marketsapce_app/screens/register_screen.dart';
import 'package:marketsapce_app/screens/user_ads_screen.dart';
import 'package:marketsapce_app/providers/users_provider.dart';
import 'package:marketsapce_app/providers/products_providers.dart';
import 'package:marketsapce_app/screens/create_advertise_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();

  Hive.init(dir.path);

  await Hive.openBox<Map>('httpCache');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProviders()),
      ],
      child: MaterialApp(
        title: 'Market Space',
        debugShowCheckedModeBanner: false,
        theme: lightModeTheme,
        initialRoute: AppRoutes.opening,
        routes: {
          AppRoutes.opening: (ctx) => OpeningScreen(),
          AppRoutes.login: (ctx) => LoginScreen(),
          AppRoutes.register: (ctx) => RegisterScreen(),
          AppRoutes.home: (ctx) => HomeScreen(),
          AppRoutes.userAdds: (ctx) => UserAdsScreen(),
          AppRoutes.createAdvertise: (ctx) => CreateAdVertiseScreen(),
        },
      ),
    );
  }
}
