import 'package:flutter/material.dart';

import '../../screens/add_education.dart';
import '../../screens/add_experience.dart';
import '../../screens/edit_aboutme.dart';
import '../../screens/edit_personal_info.dart';
import '../../screens/homepage.dart';
import '../../screens/landing_page.dart';
import '../../screens/login_screen.dart';
import '../../screens/new_password_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/projects_screen.dart';
import '../../screens/reset_code_screen.dart';
import '../../screens/selection_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case 'selection_screen':
        return MaterialPageRoute(builder: (_) => const SelectionScreen());
      case 'freelancer_login_screen':
        return MaterialPageRoute(
            builder: (_) => const LoginScreen(loginType: LoginType.freelancer));
      case 'company_login_screen':
        return MaterialPageRoute(
            builder: (_) => const LoginScreen(loginType: LoginType.company));
      case 'homepage_screen':
        return MaterialPageRoute(builder: (_) => HomePage());
      case 'projects_screen':
        return MaterialPageRoute(builder: (_) => const ProjectsScreen());
      case 'profile_screen':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case 'edit_about_me_screen':
        return MaterialPageRoute(builder: (_) => const EditAboutMe());
      case 'add_education_screen':
        return MaterialPageRoute(builder: (_) => const AddEducation());
      case 'add_experience_screen':
        return MaterialPageRoute(builder: (_) => const AddExperience());
      case 'edit_personal_info':
        return MaterialPageRoute(
            builder: (_) => const EditPersonalInformation());
      // case 'forget_password_freelancer':
      //   return MaterialPageRoute(
      //     builder: (_) => const ForgotPassword(loginType: LoginType.freelancer),
      //   );
      // case 'forget_password_company':
      //   return MaterialPageRoute(
      //     builder: (_) => const ForgotPassword(loginType: LoginType.company),
      //   );
      case 'reset_code_freelancer':
        return MaterialPageRoute(
            builder: (_) =>
                const ResetCodeScreen(loginType: LoginType.freelancer));
      case 'reset_code_company':
        return MaterialPageRoute(
            builder: (_) =>
                const ResetCodeScreen(loginType: LoginType.company));
      case 'new_password_freelancer':
        return MaterialPageRoute(
            builder: (_) =>
                const NewPasswordScreen(loginType: LoginType.freelancer));
      case 'new_password_company':
        return MaterialPageRoute(
            builder: (_) =>
                const NewPasswordScreen(loginType: LoginType.company));
      default:
        return null;
    }
  }
}
