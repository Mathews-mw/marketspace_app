import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketsapce_app/screens/account_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:marketsapce_app/screens/store_screen.dart';
import 'package:marketsapce_app/screens/user_ads_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body:
            <Widget>[
              StoreScreen(),
              UserAdsScreen(),
              AccountScreen(),
            ][_currentScreenIndex],
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          selectedIndex: _currentScreenIndex,
          onDestinationSelected: (index) {
            setState(() => _currentScreenIndex = index);
          },
          destinations: [
            NavigationDestination(
              icon: Icon(PhosphorIconsFill.house, size: 20),
              label: 'Home',
            ),

            NavigationDestination(
              icon: Icon(PhosphorIconsFill.tag, size: 20),
              label: 'Meus anúncios',
            ),
            NavigationDestination(
              icon: Icon(PhosphorIconsFill.user, size: 20),
              label: 'Conta',
            ),
          ],
        ),
      ),
    );
  }
}
