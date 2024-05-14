import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/providers/company_profile_provider.dart';
import 'package:outsourcepro/providers/navigation_provider.dart';
import 'package:outsourcepro/screens/common/change_password_screen.dart';
import 'package:outsourcepro/screens/common/login_screen.dart';
import 'package:outsourcepro/screens/company/company_profile_screen.dart';
import 'package:outsourcepro/screens/freelancer/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/community_provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/token_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 10.0.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  final String? userType =
                                      prefs?.getString('userType');
                                  if (userType == 'freelancer') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(),
                                      ),
                                    );
                                  } else if (userType == 'company') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CompanyProfile(),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.chevron_right,
                                  size: 24.r,
                                  color: primaryColor,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 10.0.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Text(
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  final String? userType =
                                      prefs.getString('userType');
                                  if (userType == 'freelancer') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ChangePasswordScreen(
                                                loginType:
                                                    LoginType.freelancer),
                                      ),
                                    );
                                  } else if (userType == 'company') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ChangePasswordScreen(
                                                loginType: LoginType.company),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.chevron_right,
                                  size: 24.r,
                                  color: primaryColor,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 10.0.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.exit_to_app_outlined,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  Provider.of<NavigationProvider>(context,
                                          listen: false)
                                      .updateIndex(0);
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .reset();
                                  Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .reset();
                                  Provider.of<CommunityProvider>(context,
                                          listen: false)
                                      .reset();
                                  Provider.of<CompanyProfileProvider>(context,
                                          listen: false)
                                      .reset();
                                  Provider.of<FreelancerProfileProvider>(
                                          context,
                                          listen: false)
                                      .reset();
                                  Provider.of<ProjectProvider>(context,
                                          listen: false)
                                      .reset();

                                  Provider.of<TokenProvider>(context,
                                          listen: false)
                                      .reset();

                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  final String? userType =
                                      prefs?.getString('userType');
                                  if (userType == 'freelancer') {
                                    Provider.of<FreelancerProfileProvider>(
                                            context,
                                            listen: false)
                                        .logout(context, 'freelancer');
                                    await prefs.clear();
                                  } else if (userType == 'company') {
                                    Provider.of<CompanyProfileProvider>(context,
                                            listen: false)
                                        .logout(context, 'company');
                                    await prefs.clear();
                                  }
                                },
                                icon: Icon(
                                  Icons.chevron_right,
                                  size: 24.r,
                                  color: primaryColor,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          )
        ],
      ),
    );
  }
}
