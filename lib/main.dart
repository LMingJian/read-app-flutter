import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:read_app/router/router.dart' as router;
import 'package:read_app/pages/start_page.dart';

/// 入口
void main() {
  runApp(const MyApp());

  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

/// app配置
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReadApp',
      theme: ThemeData(primaryColor: Colors.grey),
      // 注册路由表
      routes: router.routes,
      onGenerateRoute: router.generateRoute,
      home: const StartPage(),
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
