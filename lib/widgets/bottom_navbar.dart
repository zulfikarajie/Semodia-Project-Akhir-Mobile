import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/motor_list_page.dart';
import '../screens/maps_page.dart'; // Tambahkan import ini

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    MotorListPage(),
    MapsPage(), // Tambahkan MapsPage di sini
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.motorcycle),
            label: 'Motor List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Maps',
          ),
        ],
      ),
    );
  }
}