import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/providers/auth_provider.dart';
import 'package:outsourcepro/providers/chat_provider.dart';
import 'package:outsourcepro/providers/community_provider.dart';
import 'package:outsourcepro/providers/company_profile_provider.dart';
import 'package:outsourcepro/providers/navigation_provider.dart';
import 'package:outsourcepro/providers/password_visibility_provider.dart';
import 'package:outsourcepro/providers/project_provider.dart';
import 'package:outsourcepro/providers/search_provider.dart';
import 'package:outsourcepro/providers/team_provider.dart';
import 'package:outsourcepro/providers/token_provider.dart';
import 'package:outsourcepro/router/app_router.dart';
import 'package:outsourcepro/screens/common/landing_page.dart';
import 'package:outsourcepro/screens/common/selection_screen.dart';
import 'package:outsourcepro/screens/company/homepage_company.dart';
import 'package:outsourcepro/screens/freelancer/homepage_freelancer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:video_player/video_player.dart';
import 'Providers/freelance_profile_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  TokenProvider tokenProvider = TokenProvider();
  await tokenProvider.loadCookieFromPrefs();
  //SharedPreferences prefs = await SharedPreferences.getInstance();

  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(MyApp(navigatorKey: navigatorKey));
  });
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

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
        ChangeNotifierProxyProvider<TokenProvider, CommunityProvider>(
          create: (_) => CommunityProvider(),
          update: (_, tokenProvider, communityProvider) {
            return communityProvider!
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
        ChangeNotifierProxyProvider<TokenProvider, ChatProvider>(
          create: (_) => ChatProvider(),
          update: (_, tokenProvider, chatProvider) {
            return chatProvider!
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
            home: FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (BuildContext context,
                  AsyncSnapshot<SharedPreferences> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                      body:
                          CircularProgressIndicator()); // Show loading indicator while waiting for SharedPreferences
                } else if (snapshot.hasError) {
                  return const LandingPage(); // Show error screen if something went wrong
                } else {
                  final prefs = snapshot.data;
                  final bool isLoggedIn = prefs?.getBool('isLoggedIn') ?? false;
                  final String? userType = prefs?.getString('userType');
                  final String? cookie = prefs?.getString('cookie');

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (cookie != null && cookie.isNotEmpty) {
                      Provider.of<TokenProvider>(context, listen: false)
                          .setCookie(cookie);
                    }
                  });

                  if (!isLoggedIn) {
                    return const SelectionScreen();
                  } else if (userType == 'freelancer') {
                    return const HomePageFreelancer();
                  } else if (userType == 'company') {
                    return const HomePageCompany();
                  } else {
                    return const SelectionScreen(); // Or another appropriate screen if userType is not valid
                  }
                }
              },
            ),
            onGenerateRoute: AppRouter().onGenerateRoute,
          );
        },
      ),
    );
  }
}
