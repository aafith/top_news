import 'package:flutter/material.dart';
import 'package:top_news/screens/category_screen.dart';
import 'package:top_news/screens/home_screen.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int index = 0;

  final List<Widget> tabs = [
    const HomeScreen(),
    const CategoryScreen(
      image: '',
      name: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[index],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: const Color(0xFFFE0000),
        backgroundColor: Colors.white,
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Category',
              backgroundColor: Colors.white),
        ],
        onTap: (int index) {
          setState(() {
            this.index = index;
          });
        },
      ),
    );
  }
}
