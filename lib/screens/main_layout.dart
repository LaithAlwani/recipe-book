import 'package:flutter/material.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/screens/home/home_screen.dart';
import 'package:recipe_book/screens/profile/profile_screen.dart';
import 'package:recipe_book/screens/profile/settings_screen.dart';
import 'package:recipe_book/screens/recipe/create_recipie_screen.dart';
import 'package:recipe_book/screens/recipe/recipies_screen.dart';
import 'package:recipe_book/services/auth_service.dart';
import 'package:recipe_book/theme.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 1;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final List<String> _titles = ["Create Recipe", "My Cook Book", "Recipes"];

  void _onSelectedItem(int index) {
    if (index == 0) {
      _navigatorKey.currentState!.pushNamed('/create');
    } else if (index == 1) {
      _navigatorKey.currentState!.pushNamed('/home');
    } else if (index == 2) {
      _navigatorKey.currentState!.pushNamed('/recipes');
    }

    setState(() => _selectedIndex = index);
  }

  Color iconColor(index) {
    return _selectedIndex == index ? AppColors.primaryColor : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SettingScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          Widget page = const HomeScreen();

          if (settings.name == '/') {
            page = const HomeScreen();
          } else if (settings.name == '/recipes') {
            page = const RecipesScreen();
          } else if (settings.name == '/create') {
            page = const CreateRecipieScreen();
          } else if (settings.name == '/settings') {
            page = const SettingScreen();
          }
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => ColoredBox(
              color: AppColors.backgroundColor, // Prevent white flash
              child: page,
            ),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 150),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onSelectedItem,
        indicatorColor: Colors.transparent,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.add_circle, color: iconColor(0)),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(Icons.home, color: iconColor(1)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book, color: iconColor(2)),
            label: 'Recipies',
          ),
        ],
        height: 60,
        backgroundColor: AppColors.backgroundColor,
        shadowColor: Colors.grey,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
