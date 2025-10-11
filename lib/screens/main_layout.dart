import 'package:flutter/material.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/screens/home/home_screen.dart';
import 'package:recipe_book/screens/profile/profile_screen.dart';
import 'package:recipe_book/screens/recipies/create_recipie_screen.dart';
import 'package:recipe_book/screens/recipies/recipies_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.user});

  final AppUser user;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 1;
  late Widget _selectedScreen = HomeScreen(user: widget.user);

  void _onSelectedItem(int index) {
    if (index == 0) {
      // ➕ Create page opens as a separate route
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateRecipieScreen(user: widget.user),
        ),
      );
    } else if (index == 1) {
      // Home tab
      setState(() {
        _selectedScreen = HomeScreen(user: widget.user);
        _selectedIndex = 1;
      });
    } else if (index == 2) {
      // Recipes tab
      setState(() {
        _selectedScreen = const RecipiesScreen();
        _selectedIndex = 2; // maps to RecipesScreen in _pages
      });
    }
  }

  Color iconColor(index) {
    return _selectedIndex == index ? Colors.amber : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const Profilescreen()));
            },
            borderRadius: BorderRadius.circular(20),
            child: CircleAvatar(
              backgroundImage:
                    widget.user.photoUrl != null &&
                        widget.user.photoUrl!.isNotEmpty
                    ? NetworkImage(widget.user.photoUrl!)
                    : const AssetImage('assets/images/avatar_placeholder.png')
                          as ImageProvider,
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=> Profilescreen(user: widget.user)));
          //   },
          //   icon: const Icon(Icons.manage_accounts_sharp),
          // ),
        ],
      ),
      body: _selectedScreen,
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
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
