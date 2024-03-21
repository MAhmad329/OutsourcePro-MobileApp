import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/providers/auth_provider.dart';
import 'package:outsourcepro/providers/navigation_provider.dart';
import 'package:outsourcepro/providers/password_visibility_provider.dart';
import 'package:outsourcepro/providers/project_provider.dart';
import 'package:outsourcepro/providers/search_provider.dart';
import 'package:outsourcepro/providers/token_provider.dart';
import 'package:outsourcepro/screens/add_education.dart';
import 'package:outsourcepro/screens/add_experience.dart';
import 'package:outsourcepro/screens/edit_aboutme.dart';
import 'package:outsourcepro/screens/edit_personal_info.dart';
import 'package:outsourcepro/screens/homepage.dart';
import 'package:outsourcepro/screens/landing_page.dart';
import 'package:outsourcepro/screens/login_screen.dart';
import 'package:outsourcepro/screens/profile_screen.dart';
import 'package:outsourcepro/screens/projects_screen.dart';
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
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(
            create: (context) => PasswordVisibilityProvider()),
        ChangeNotifierProvider(create: (context) => TokenProvider()),
        // ChangeNotifierProxyProvider2<TokenProvider, CookieProvider,
        //         FreelancerProfileProvider>(
        //     create: (_) => FreelancerProfileProvider(),
        //     update: (_, ipAddressProvider, authProvider,
        //         freelancerProfileProvider) {
        //       return freelancerProfileProvider!
        //         ..updateDependencies(
        //           ipAddressProvider.ipaddress,
        //           authProvider.cookie,
        //         );
        //     }),
        // ChangeNotifierProxyProvider2<IPAddressProvider, CookieProvider,
        //         ProjectProvider>(
        //     create: (_) => ProjectProvider(),
        //     update: (_, ipAddressProvider, cookieProvider, projectProvider) {
        //       return projectProvider!
        //         ..updateDependencies(
        //           ipAddressProvider.ipaddress,
        //           cookieProvider.cookie,
        //         );
        //     }),
        ChangeNotifierProxyProvider<TokenProvider, FreelancerProfileProvider>(
          create: (_) => FreelancerProfileProvider(),
          update: (_, tokenProvider, freelanceProvider) {
            return freelanceProvider!
              ..updateDependencies(
                  tokenProvider.ipaddress, tokenProvider.cookie);
          },
        ),
        ChangeNotifierProxyProvider<TokenProvider, ProjectProvider>(
          create: (_) => ProjectProvider(),
          update: (_, tokenProvider, projectProvider) {
            return projectProvider!
              ..updateDependencies(
                  tokenProvider.ipaddress, tokenProvider.cookie);
          },
        ),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
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
              'projects_screen': (context) => const ProjectsScreen(),
              'profile_screen': (context) => const ProfileScreen(),
              'edit_about_me_screen': (context) => const EditAboutMe(),
              'add_education_screen': (context) => const AddEducation(),
              'add_experience_screen': (context) => const AddExperience(),
              'edit_personal_info': (context) =>
                  const EditPersonalInformation(),
            },
          );
        },
      ),
    );
  }
}
