import 'package:flutter/material.dart';
import 'package:recipe_book/features/home/ui/home_screen.dart';
import 'package:recipe_book/features/user/ui/settings_screen.dart';
import 'package:recipe_book/features/recipie/ui/create_recipie_screen.dart';
import 'package:recipe_book/features/recipie/ui/recipies_screen.dart';
import 'package:recipe_book/theme.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 1;

  final List<Widget> _pages = const [
    CreateRecipieScreen(),
    HomeScreen(),
    RecipesScreen(),
  ];

  final List<String> _titles = ["Create Recipe", "My Cook Book", "Recipes"];

  void _onSelectedItem(int index) {
    setState(() => _selectedIndex = index);
  }

  Color iconColor(int index) {
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
              // Navigate to Settings on top of current page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
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
