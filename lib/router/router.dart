import 'package:flutter/material.dart';
import 'package:read/pages/home_page.dart';
import 'package:read/pages/history_page.dart';
import 'package:read/pages/more_page.dart';
import 'package:read/pages/search_page.dart';
import 'package:read/pages/source_page.dart';

final routes = {
  "/search": (context) => const SearchPage(),
  "/history": (context) => const HistoryPage(),
  "/source": (context) => const SourcePage(),
  "/more": (context) => const MorePage(),
  "/home": (context) => const MainPage(),
};

Route generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/search':
      return MaterialPageRoute(builder: (context) => const SearchPage());
    case '/history':
      return MaterialPageRoute(builder: (context) => const HistoryPage());
    case '/source':
      return MaterialPageRoute(builder: (context) => const SourcePage());
    case '/more':
      return MaterialPageRoute(builder: (context) => const MorePage());
    case '/home':
      return MaterialPageRoute(builder: (context) => const MainPage());
    default:
      return MaterialPageRoute(builder: (context) => const MainPage());
  }
}
