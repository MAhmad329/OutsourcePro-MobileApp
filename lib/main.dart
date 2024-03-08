import 'package:flutter/material.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/screens/addEducation.dart';
import 'package:outsourcepro/screens/addExperience.dart';
import 'package:outsourcepro/screens/editAboutMe.dart';
import 'package:outsourcepro/screens/loginScreen.dart';
import 'package:outsourcepro/screens/homepage.dart';
import 'package:outsourcepro/screens/homepageFreelancer.dart';
import 'package:outsourcepro/screens/landingPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/screens/profileScreen.dart';
import 'package:outsourcepro/screens/selectionScreen.dart';
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
        ChangeNotifierProvider(
            create: (context) => FreelancerProfileProvider(
                  context: context,
                )),
        // Add more providers as needed
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
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
  String? cookie;

  void setCookie(String value) {
    cookie = value;
    notifyListeners();
  }
}

class IPAddressProvider extends ChangeNotifier {
  String ipaddress = '192.168.45.124';
}
