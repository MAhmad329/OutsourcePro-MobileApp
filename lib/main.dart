import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/providers/auth_provider.dart';
import 'package:outsourcepro/providers/navigation_provider.dart';
import 'package:outsourcepro/providers/password_visibility_provider.dart';
import 'package:outsourcepro/providers/project_provider.dart';
import 'package:outsourcepro/providers/search_provider.dart';
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
