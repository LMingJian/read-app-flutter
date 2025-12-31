import 'package:flutter/material.dart';
import 'package:read_app/function/func.dart';
import 'package:read_app/utils/file_utils.dart';
import 'package:read_app/utils/shared_preferences_utils.dart';

/// 搜索界面
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  bool ifLoading = false;
  List result = [];
  String keyWord = '';
  int keyPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Center(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
            SizedBox.fromSize(
              size: const Size(450, 45),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (str) async {
                  keyWord = str;
                  keyPage = 1;
                  setState(() {
                    ifLoading = true;
                  });
                  result = await Func.search(str);
                  setState(() {
                    ifLoading = false;
                  });
                },
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.fromSize(
                  size: const Size(170, 60),
                  child: OutlinedButton(
                    child: const Text(
                      '上一页',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        ifLoading = true;
                      });
                      if (keyWord != '' && keyPage > 1) {
                        keyPage--;
                        result = await Func.search(keyWord, page: keyPage);
                      }
                      setState(() {
                        ifLoading = false;
                      });
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                SizedBox.fromSize(
                  size: const Size(170, 60),
                  child: OutlinedButton(
                    child: const Text(
                      '下一页',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        ifLoading = true;
                      });
                      if (keyWord != '') {
                        keyPage++;
                        result = await Func.search(keyWord, page: keyPage);
                      }
                      setState(() {
                        ifLoading = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
            _childLayout(),
          ],
        ),
      ),
    );
  }

  Widget _childLayout() {
    if (ifLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      // 使用Expanded包括，否则滚动无法生效
      if (result.isNotEmpty) {
        List<Widget> btn = [];
        for (var item in result) {
          btn.add(btnList(item.name, item.url));
        }
        return Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 25.0,
              horizontal: 25.0,
            ),
            child: Wrap(spacing: 25.0, runSpacing: 15, children: btn),
          ),
        );
      } else {
        return const Expanded(child: SingleChildScrollView(child: Text('无结果')));
      }
    }
  }

  Widget btnList(String name, String url) {
    return SizedBox(
      height: 60.0,
      child: OutlinedButton(
        child: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          // 记录选择
          debugPrint('当前选择书籍链接为: $url');
          SharedPreferencesUtils.setData('indexUrl', url);
          SharedPreferencesUtils.setData('indexUrlFlag', url);
          FileUtils.writeLibraryFile('history.txt', '$name+$url');
          Navigator.pushNamed(context, '/home');
        },
      ),
    );
  }
}
