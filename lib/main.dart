import 'package:flutter/material.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/screens/add_education.dart';
import 'package:outsourcepro/screens/add_experience.dart';
import 'package:outsourcepro/screens/edit_aboutme.dart';
import 'package:outsourcepro/screens/login_screen.dart';
import 'package:outsourcepro/screens/homepage.dart';
import 'package:outsourcepro/screens/homepage_freelancer.dart';
import 'package:outsourcepro/screens/landing_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/screens/profile_screen.dart';
import 'package:outsourcepro/screens/selection_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => IPAddressProvider()),
        ChangeNotifierProxyProvider2<IPAddressProvider, AuthenticationProvider,
                FreelancerProfileProvider>(
            create: (_) => FreelancerProfileProvider(), // Initial empty values
            update: (_, ipAddressProvider, authProvider,
                freelancerProfileProvider) {
              return freelancerProfileProvider!
                ..updateDependencies(
                  ipAddressProvider.ipaddress,
                  authProvider.cookie,
                );
            }),
        // Add more providers as needed
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            theme: ThemeData(fontFamily: 'Poppins'),
            debugShowCheckedModeBanner: false,
            initialRoute: 'landing_screen',
            routes: {
              'landing_screen': (context) => const LandingPage(),
              'selection_screen': (context) => const SelectionScreen(),
              'freelancer_login_screen': (context) => const LoginScreen(
                    loginType: LoginType.freelancer,
                  ),
              'company_login_screen': (context) => const LoginScreen(
                    loginType: LoginType.company,
                  ),
              'homepage_screen': (context) => const HomePage(),
              'homepage_freelancer_screen': (context) =>
                  const HomepageFreelancer(),
              'profile_screen': (context) => const ProfileScreen(),
              'edit_about_me_screen': (context) => const EditAboutMe(),
              'add_education_screen': (context) => const AddEducation(),
              'add_experience_screen': (context) => const AddExperience(),
            },
          );
        },
      ),
    );
  }
}

class AuthenticationProvider extends ChangeNotifier {
  String cookie = '';

  void setCookie(String value) {
    cookie = value;
    notifyListeners();
  }
}

class IPAddressProvider extends ChangeNotifier {
  String ipaddress = '192.168.0.113';
}
