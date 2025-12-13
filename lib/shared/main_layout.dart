import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/home/ui/home_screen.dart';
import 'package:recipe_book/features/recipe_list/recipe_list_provider.dart';
import 'package:recipe_book/features/recipe_list/recipe_list_screen.dart';
import 'package:recipe_book/features/recipie/ui/create/create_recipe_screen.dart';
import 'package:recipe_book/features/settings/settings_screen.dart';
import 'package:recipe_book/theme.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int _selectedIndex = 1;

  final List<String> _titles = [
    "Create Recipe",
    "My Kitchen Recipes",
    "Recipes",
  ];

  void _onSelectedItem(int index) {
    setState(() => _selectedIndex = index);
  }

  Color iconColor(int index) {
    return _selectedIndex == index ? AppColors.primaryColor : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final homeVM = ref.read(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);
    final ownerId = authState.appUser?.uid; // or .id depending on your model

    final List<Widget> _pages = [
      const CreateRecipeScreen(),
      const HomeScreen(),
      RecipeListScreen(
        title: "Recipes",
        query: RecipeListQuery(ownerId: ownerId),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigate to Settings on top of current page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingScreen()),
            );
          },
          icon: const Icon(Icons.settings),
        ),
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await homeVM.signOut();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Logout succesfully, See you later!"),
                  ),
                );
              }
            },
            icon: const Icon(Icons.logout),
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
            label: 'Recipes',
          ),
        ],
        height: 60,
        // backgroundColor: AppColors.backgroundColor,
        shadowColor: Colors.grey,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
