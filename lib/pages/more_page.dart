import 'package:flutter/material.dart';

/// 更多界面
class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tools'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 25.0, left: 25.0),
        child: Wrap(spacing: 25.0, runSpacing: 15, children: [
          btnList(context, '搜索配置', '/search'),
          btnList(context, '阅读历史', '/history'),
          btnList(context, '书源配置', '/source'),
        ]),
      ),
    );
  }

  Widget btnList(BuildContext context, String str, String router) {
    return SizedBox.fromSize(
      size: const Size(170, 60),
      child: OutlinedButton(
        child: Text(
          str,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        onPressed: () => Navigator.pushNamed(context, router),
      ),
    );
  }
}
