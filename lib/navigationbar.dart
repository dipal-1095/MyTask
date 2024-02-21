import 'package:flutter/material.dart';
import 'package:loginusingsharedpref/Profile.dart';
import 'package:loginusingsharedpref/api_item_fetch.dart';
import 'package:loginusingsharedpref/themes/colors.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({Key? key}) : super(key: key);

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final List<StatefulWidget> list = [
    const ApiDataItemFetch(),
    const Profile(),
  ];
  int selected_index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(index: selected_index, children: list),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.bottomAppbarColor,
          currentIndex: selected_index,
          onTap: onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'Item',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void onItemTapped(int index) {
    if (selected_index != index) {
      setState(() {
        selected_index = index;
      });
    }
  }
}
