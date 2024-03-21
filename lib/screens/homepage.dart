import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import 'projects_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final List<Widget> _screens = const [
    ProjectsScreen(),
    Scaffold(
      body: Center(
        child: Text('2nd screen'),
      ),
    ),
    Scaffold(
      body: Center(
        child: Text('3rd screen'),
      ),
    ),
    ProfileScreen(),
    // Add more screens here
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        if (navigationProvider.currentIndex != 0) {
          navigationProvider.updateIndex(0); // Navigate to HomepageFreelancer
          return false; // Prevent default back button behavior
        }
        return true; // Allow back button behavior if on HomepageFreelancer
      },
      child: Scaffold(
        body: IndexedStack(
          index: navigationProvider.currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationProvider.currentIndex,
          onTap: (index) => navigationProvider.updateIndex(index),
          iconSize: 20.r,
          unselectedItemColor: Colors.grey,
          selectedItemColor: primaryColor,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups),
              label: 'Teams', // Replace with your actual labels
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats', // Replace with your actual labels
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile', // Replace with your actual labels
            ),
            // Add more items here
          ],
        ),
      ),
    );
  }
}
