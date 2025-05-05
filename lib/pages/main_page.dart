import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/pages/parameters_page.dart';
import 'favorites_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;

  /// List of pages to navigate to
  final List<Widget> _pagesList = [
    const FavoritesPage(),
    const HomePage(),
    const ParametersPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for curved navigation bar to blend with background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _pagesList[_currentIndex],
      ),

     bottomNavigationBar: CurvedNavigationBar(
       onTap: _onItemTapped,
       index: _currentIndex,
       height: 65,
       backgroundColor: Colors.transparent,
       color: Colors.white.withOpacity(0.2), // Semi-transparent white
       buttonBackgroundColor: Colors.deepPurple.withOpacity(0.8), // Active button color
       items: <Widget>[
         Container(
           padding: const EdgeInsets.all(8),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(12),
             color: _currentIndex == 0 ? Colors.deepPurple.withOpacity(0.5) : Colors.transparent,
           ),
           child: Icon(
             Icons.favorite,
             color: _currentIndex == 0 ? Colors.white : Colors.white.withOpacity(0.7),
             size: 30,
           ),
         ),
         Container(
           padding: const EdgeInsets.all(8),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(12),
             color: _currentIndex == 1 ? Colors.deepPurple.withOpacity(0.5) : Colors.transparent,
           ),
           child: Icon(
             Icons.home,
             color: _currentIndex == 1 ? Colors.white : Colors.white.withOpacity(0.7),
             size: 30,
           ),
         ),
         Container(
           padding: const EdgeInsets.all(8),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(12),
             color: _currentIndex == 2 ? Colors.deepPurple.withOpacity(0.5) : Colors.transparent,
           ),
           child: Icon(
             Icons.settings,
             color: _currentIndex == 2 ? Colors.white : Colors.white.withOpacity(0.7),
             size: 30,
           ),
         ),
       ],
       animationDuration: const Duration(milliseconds: 400),
       animationCurve: Curves.fastOutSlowIn,
       letIndexChange: (index) => true,
     ),

    );
  }
}