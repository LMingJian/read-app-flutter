import 'package:flutter/material.dart';
import 'package:read/api/api.dart';
import 'package:read/utils/toast_utils.dart';

/// 历史
class SourcePage extends StatefulWidget {
  const SourcePage({Key? key}) : super(key: key);

  @override
  State<SourcePage> createState() => _SourcePage();
}

class _SourcePage extends State<SourcePage> {
  List<Widget> boxes = [];
  dynamic _newValue = 0;

  @override
  void initState() {
    super.initState();
    _newValue = BookSource.currentSource;
  }

  @override
  Widget build(BuildContext context) {
    boxes = [];
    for (var each in BookSource.sourceList) {
      boxes.add(_box(each.bookSourceName, each.id));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Source'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: boxes,
        ),
      ),
    );
  }

  Widget _box(String str, int value) {
    return RadioListTile(
        value: value,
        title: Text(str, style: const TextStyle(fontSize: 18)),
        groupValue: _newValue,
        onChanged: (value) {
          setState(() {
            _newValue = value;
            BookSource.setCurrentSource(_newValue);
            ToastUtils.show('书源切换成功');
            Navigator.pushNamed(context, '/home');
          });
        });
  }
}
