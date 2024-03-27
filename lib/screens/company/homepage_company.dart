import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/screens/company/company_profile_screen.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/navigation_provider.dart';

class HomePageCompany extends StatefulWidget {
  const HomePageCompany({super.key});

  @override
  State<HomePageCompany> createState() => _HomePageCompanyState();
}

class _HomePageCompanyState extends State<HomePageCompany> {
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
            Scaffold(
              body: Center(
                child: Text('1st screen'),
              ),
            ),
            Scaffold(
              body: Center(
                child: Text('2nd screen'),
              ),
            ),
            CompanyProfile(),
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
              icon: Icon(Icons.person),
              label: 'Profile', // Replace with your actual labels
            ),
          ],
        ),
      ),
    );
  }
}