import 'package:events_planning/main.dart';
import 'package:events_planning/presentation/pages/edit_profile.dart';
import 'package:events_planning/presentation/pages/intro_page.dart';
import 'package:events_planning/presentation/pages/login.dart';
import 'package:events_planning/presentation/pages/pages.dart';
import 'package:events_planning/presentation/pages/preferences.dart';
import 'package:events_planning/presentation/pages/profile_page.dart';
import 'package:events_planning/presentation/pages/reg.dart';
import 'package:events_planning/presentation/pages/welcome.dart';
import 'package:events_planning/presentation/routes/argument_bundle.dart';
import 'package:flutter/material.dart';

import '../pages/detail_category_task_page.dart';
import 'page_path.dart';

class PageRouter {
  final RouteObserver<PageRoute> routeObserver;

  PageRouter() : routeObserver = RouteObserver<PageRoute>();

  Route<dynamic> getRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case PagePath.splash:
        return _buildRoute(settings, SplashPage());
      // case PagePath.onBoard:
      //   return _buildRoute(settings, OnBoardPage());
      case PagePath.base:
        return _buildRoute(settings, BasePage());
      case PagePath.profile:
        return _buildRoute(settings, ProfilePage());
      case PagePath.about_app:
        return _buildRoute(settings, AboutAppPage());
      case PagePath.preferences:
        return _buildRoute(settings, PreferencesPage());
      case PagePath.detailCategory:
        return _buildRoute(
          settings,
          DetailCategoryTaskPage(
            bundle: args as ArgumentBundle,
          ),
        );
      case PagePath.welcome:
        return _buildRoute(settings, WelcomeScreen());
      case PagePath.auth:
        return _buildRoute(settings, Login());
      case PagePath.registration:
        return _buildRoute(settings, Reg());
      case PagePath.clientList:
        return _buildRoute(settings, ClientList(bundle: args as ArgumentBundle));
      case PagePath.editProfile:
        return _buildRoute(settings, EditProfilePage());
      case PagePath.intro_page:
        return _buildRoute(settings, OnBoardingPage());
      // case PagePath.onGoingComplete:
      //   return _buildRoute(
      //     settings,
      //     OnGoingCompletePage(
      //       bundle: args as ArgumentBundle,
      //     ),
      //   );

      case PagePath.search:
        return _buildRoute(settings, SearchPage());
      default:
        return _errorRoute();
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Ошибка'),
        ),
        body: Center(
          child: Text('ОШИБКА'),
        ),
      );
    });
  }
}
