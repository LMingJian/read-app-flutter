import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//资源卡片组件
class ToastUtils {
  //无透明效果，有动画
  static void show(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}
