import 'package:flutter/material.dart';
import 'package:read/utils/file_utils.dart';
import 'package:read/utils/shared_preferences_utils.dart';
import 'package:read/utils/toast_utils.dart';

/// 历史
class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPage();
}

class _HistoryPage extends State<HistoryPage> {
  List<Widget> boxes = [];
  List historyList = [];

  @override
  void initState() {
    super.initState();
    historyList = FileUtils.readLibraryFile('history.txt');
  }

  @override
  Widget build(BuildContext context) {
    boxes = [];
    if (historyList.isNotEmpty) {
      for (String each in historyList) {
        List res = each.split('+');
        String name = res[0];
        String url = res[1];
        boxes.add(_box(name, url));
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          // 导航栏右侧菜单
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              FileUtils.removeLibraryFile('history.txt');
              ToastUtils.show('历史清空成功');
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
              child: Wrap(
                spacing: 25.0,
                runSpacing: 15,
                children: boxes,
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _box(String str, String url) {
    return TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          overlayColor: MaterialStateProperty.all<Color>(Colors.grey),
          minimumSize: MaterialStateProperty.all(const Size(600, 60)),
        ),
        onPressed: () {
          // 记录选择
          debugPrint('当前书籍链接：$url');
          SharedPreferencesUtils.setData('indexUrl', url);
          SharedPreferencesUtils.setData('indexUrlFlag', url);
          Navigator.pushNamed(context, '/home');
        },
        child: Text(str, style: const TextStyle(fontSize: 18)));
  }
}
