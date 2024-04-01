import 'package:flutter/material.dart';
import 'package:outsourcepro/screens/company/homepage_company.dart';
import 'package:outsourcepro/screens/freelancer/chats_screen.dart';

import '../screens/common/landing_page.dart';
import '../screens/common/login_screen.dart';
import '../screens/common/new_password_screen.dart';
import '../screens/common/reset_code_screen.dart';
import '../screens/common/selection_screen.dart';
import '../screens/freelancer/add_education.dart';
import '../screens/freelancer/add_experience.dart';
import '../screens/freelancer/edit_aboutme.dart';
import '../screens/freelancer/edit_personal_info.dart';
import '../screens/freelancer/homepage_freelancer.dart';
import '../screens/freelancer/profile_screen.dart';
import '../screens/freelancer/projects_screen.dart';

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
      case 'homepage_freelancer_screen':
        return MaterialPageRoute(builder: (_) => const HomePageFreelancer());
      case 'homepage_company_screen':
        return MaterialPageRoute(builder: (_) => const HomePageCompany());
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
      case 'chats_screen':
        return MaterialPageRoute(builder: (_) => const ChatsScreen());
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
