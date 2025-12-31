import 'dart:async';
import 'package:flutter/material.dart';
import 'package:read_app/api/api.dart';
import 'package:read_app/pages/home_page.dart';
import 'package:read_app/utils/file_utils.dart';
import 'package:read_app/utils/net_utils.dart';

/// 启动页
class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    NetUtils.init();
    FileUtils.init();
    BookSource.init();
    var duration = const Duration(seconds: 3);
    Timer(duration, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset('assets/images/open_image.png', fit: BoxFit.cover),
      ),
    );
  }
}
