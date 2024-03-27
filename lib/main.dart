import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/providers/auth_provider.dart';
import 'package:outsourcepro/providers/company_profile_provider.dart';
import 'package:outsourcepro/providers/navigation_provider.dart';
import 'package:outsourcepro/providers/password_visibility_provider.dart';
import 'package:outsourcepro/providers/project_provider.dart';
import 'package:outsourcepro/providers/search_provider.dart';
import 'package:outsourcepro/providers/team_provider.dart';
import 'package:outsourcepro/providers/token_provider.dart';
import 'package:outsourcepro/router/app_router.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(MyApp());
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
        ChangeNotifierProxyProvider<TokenProvider, FreelancerProfileProvider>(
          create: (_) => FreelancerProfileProvider(),
          update: (_, tokenProvider, freelanceProvider) {
            return freelanceProvider!
              ..updateDependencies(
                  tokenProvider.ipaddress, tokenProvider.cookie);
          },
        ),
        ChangeNotifierProxyProvider<TokenProvider, CompanyProfileProvider>(
          create: (_) => CompanyProfileProvider(),
          update: (_, tokenProvider, companyProvider) {
            return companyProvider!
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
        ChangeNotifierProxyProvider<TokenProvider, TeamProvider>(
          create: (_) => TeamProvider(),
          update: (_, tokenProvider, teamProvider) {
            return teamProvider!
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
            navigatorKey: navigatorKey,
            theme: ThemeData(fontFamily: 'Poppins'),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter().onGenerateRoute,
          );
        },
      ),
    );
  }
}
