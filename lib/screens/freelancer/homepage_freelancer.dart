import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/screens/common/community_forum.dart';
import 'package:outsourcepro/screens/common/settings_screen.dart';
import 'package:outsourcepro/screens/freelancer/chats_screen.dart';
import 'package:outsourcepro/screens/freelancer/manage_projects.dart';
import 'package:outsourcepro/screens/freelancer/team_page.dart';
import 'package:provider/provider.dart';

import '../../Providers/freelance_profile_provider.dart';
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
    Provider.of<FreelancerProfileProvider>(context, listen: false)
        .fetchFreelancerDetails();
    _pageController = PageController(
      initialPage:
          Provider.of<NavigationProvider>(context, listen: false).currentIndex,
    );
    _pageController.addListener(() {
      final pageIndex = _pageController.page?.round();
      if (pageIndex != null &&
          pageIndex !=
              Provider.of<NavigationProvider>(context, listen: false)
                  .currentIndex) {
        Provider.of<NavigationProvider>(context, listen: false)
            .updateIndex(pageIndex);
      }
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(() {}); // Remove the listener
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    print(
        'FUCKID: ${Provider.of<FreelancerProfileProvider>(context, listen: false).profile.id}');

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
          children: [
            ProjectsScreen(),
            ManageProjects(),
            TeamPage(),
            ChatsScreen(),
            CommunityForum(),
            SettingsScreen(),
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
              label: 'Teams',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
