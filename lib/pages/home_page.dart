import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:read/function/func.dart';
import 'package:read/utils/bus_utils.dart';
import 'package:read/utils/shared_preferences_utils.dart';
import 'package:read/utils/toast_utils.dart';

///主界面
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  ///加载动画播放标志
  bool ifLoading = false;
  ///目录
  List index = [];
  ///正文内容
  String content = '';
  ///当前章数
  int nowIndex = -1;
  ///目录长度
  int indexLen = 0;

  ///事件总线（不使用）
  void busEventInit() {
    debugPrint('busEvent 启动');
    BusUtils.off(BusUtils.notLogin);
    BusUtils.on(BusUtils.notLogin, (arg) {
      debugPrint('busEvent $arg');
      debugPrint('busEvent OK');
    });
  }

  @override
  void initState() {
    super.initState();
    busEventInit();
    ///获取上次阅读历史（链接+章节）
    SharedPreferencesUtils.getData("indexUrlFlag").then((value) {
      if (value != null && value != '') {
        setState(() {
          ifLoading = true;
        });
        debugPrint('当前书籍链接：$value');
        ToastUtils.show('当前书籍链接：$value');
        ///获取目录
        Func.index(value).then((data) {
          if (data.isNotEmpty) {
            ToastUtils.show('获取目录成功');
            SharedPreferencesUtils.setData("indexUrlFlag", '');
            index = data;
            indexLen = index.length;
            setState(() {
              ifLoading = false;
            });
          }else{
            ToastUtils.show('获取目录失败');
            setState(() {
              ifLoading = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressedAt;
    return WillPopScope(
        onWillPop: () async {
          // 点击返回键即触发该事件
          if (lastPressedAt == null) {
            ToastUtils.show("再按一次退出");
          }
          if (lastPressedAt == null ||
              DateTime.now().difference(lastPressedAt!) >
                  const Duration(seconds: 2)) {
            // 两次点击间隔超过1秒则重新计时
            lastPressedAt = DateTime.now();
            ToastUtils.show("再按一次退出");
            return false;
          }
          SystemNavigator.pop();
          exit(0);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Read'),
            actions: [
              //导航栏右侧菜单
              IconButton(
                icon: const Icon(Icons.more),
                onPressed: () => Navigator.pushNamed(context, '/more'),
              ),
            ],
          ),
          drawer: _drawer(),
          //监听抽屉关闭状态，点击事件，执行阅读
          onDrawerChanged: (drawer) async {
            if (!drawer) {
              debugPrint('抽屉关闭');
            }
          },
          body: _centerBody(content),
          bottomNavigationBar: _bottomBar(),
        ));
  }

  ///正文部件
  Widget _centerBody(String str) {
    if (ifLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 70),
        child: SizedBox(
            child: Text(str,
                style: const TextStyle(color: Colors.black, fontSize: 25))),
      );
    }
  }

  ///侧边栏
  Widget _drawer() {
    return SizedBox(
      width: 200,
      child: Drawer(
        child: MediaQuery.removePadding(
          context: context,
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: ListView.builder(
                key: const PageStorageKey<String>('offset'),
                controller: ScrollController(),
                itemCount: index.length,
                itemBuilder: (BuildContext context, int i) {
                  return TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        debugPrint('当前选择章节: $i');
                        nowIndex = i;
                        setState(() {
                          ifLoading = true;
                        });
                        SharedPreferencesUtils.setData("nowIndex", nowIndex);
                        content = '';
                        Func.content(index[i].url).then((value) {
                          if (value.isNotEmpty) {
                            for (var each in value) {
                              content = content + each;
                            }
                          }
                          setState(() {
                            ifLoading = false;
                          });
                        });
                      },
                      child: Text(index[i].name,
                          style: const TextStyle(color: Colors.black)));
                }),
          ),
        ),
      ),
    );
  }

  ///底部工具栏
  Widget _bottomBar() {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                Icons.watch_later_outlined,
                size: 35,
              ),
              onPressed: () async {
                ///历史章节
                dynamic num = await SharedPreferencesUtils.getData("nowIndex");
                SharedPreferencesUtils.getData("indexUrl").then((value) {
                  if (value != null && value != '') {
                    setState(() {
                      ifLoading = true;
                    });
                    debugPrint('当前历史链接：$value');
                    Func.index(value).then((data) {
                      if (data.isNotEmpty) {
                        ToastUtils.show('获取历史成功');
                        index = data;
                        indexLen = index.length;
                        if (num != null) {
                          nowIndex = num;
                          content = '';
                          Func.content(index[nowIndex].url).then((value) {
                            if (value.isNotEmpty) {
                              for (var each in value) {
                                content = '${content + each}\n\n';
                              }
                            }
                            setState(() {
                              ifLoading = false;
                            });
                          });
                        }else{
                          ToastUtils.show('章节获取失败');
                          setState(() {
                            ifLoading = false;
                          });
                        }
                      }else{
                        ToastUtils.show('获取历史失败');
                        setState(() {
                          ifLoading = false;
                        });
                      }
                    });
                  }
                });
              },
            ), //
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 35,
              ),
              onPressed: () async {
                debugPrint('上一章');
                if (nowIndex != -1 && nowIndex != 0) {
                  nowIndex = nowIndex - 1;
                  if (nowIndex >= 0) {
                    setState(() {
                      ifLoading = true;
                    });
                    SharedPreferencesUtils.setData("nowIndex", nowIndex);
                    content = '';
                    Func.content(index[nowIndex].url).then((value) {
                      if (value.isNotEmpty) {
                        for (var each in value) {
                          content = content + each;
                        }
                      }
                      setState(() {
                        ifLoading = false;
                      });
                    });
                  }
                }else{
                  ToastUtils.show('没有了');
                }
              },
            ), //
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                Icons.refresh_outlined,
                size: 35,
              ),
              onPressed: () async {
                debugPrint('刷新');
                if (nowIndex != -1 && nowIndex < indexLen) {
                  setState(() {
                    ifLoading = true;
                  });
                  SharedPreferencesUtils.setData("nowIndex", nowIndex);
                  content = '';
                  Func.content(index[nowIndex].url).then((value) {
                    if (value.isNotEmpty) {
                      for (var each in value) {
                        content = content + each;
                      }
                    }
                    setState(() {
                      ifLoading = false;
                    });
                  });
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward,
                size: 35,
              ),
              onPressed: () async {
                debugPrint('下一章');
                if (nowIndex != -1) {
                  nowIndex = nowIndex + 1;
                  if (nowIndex == indexLen) {
                    nowIndex = indexLen - 1;
                    ToastUtils.show('最后了');
                  } else {
                    setState(() {
                      ifLoading = true;
                    });
                    SharedPreferencesUtils.setData("nowIndex", nowIndex);
                    content = '';
                    Func.content(index[nowIndex].url).then((value) {
                      if (value.isNotEmpty) {
                        for (var each in value) {
                          content = content + each;
                        }
                      }
                      setState(() {
                        ifLoading = false;
                      });
                    });
                  }
                }
              },
            ),
          ),
        ], //均分底部导航栏横向空间
      ),
    );
  }
}
