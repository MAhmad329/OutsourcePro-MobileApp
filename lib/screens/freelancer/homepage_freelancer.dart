import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/screens/freelancer/manage_projects.dart';
import 'package:outsourcepro/screens/freelancer/profile_screen.dart';
import 'package:outsourcepro/screens/freelancer/team_page.dart';
import 'package:provider/provider.dart';

import '../../providers/navigation_provider.dart';
import 'projects_screen.dart';

class HomePageFreelancer extends StatefulWidget {
  const HomePageFreelancer({super.key});

  @override
  State<HomePageFreelancer> createState() => _HomePageFreelancerState();
}

class _HomePageFreelancerState extends State<HomePageFreelancer> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        if (navigationProvider.currentIndex != 0) {
          navigationProvider.updateIndex(0);
          _pageController.jumpToPage(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) => navigationProvider.updateIndex(index),
          children: const [
            ProjectsScreen(),
            ManageProjects(), TeamPage(),
            Scaffold(
              body: Center(
                child: Text('4th screen'),
              ),
            ),
            ProfileScreen(),
            // Add more screens here
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationProvider.currentIndex,
          onTap: (index) {
            navigationProvider.updateIndex(index);
            _pageController.jumpToPage(index);
          },
          iconSize: 20.r,
          unselectedItemColor: Colors.grey,
          selectedItemColor: primaryColor,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
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
