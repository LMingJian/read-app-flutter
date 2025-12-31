import 'package:shared_preferences/shared_preferences.dart';

// shared_preferences 使用的存储方式是 key-value 形式。

// 虽然使用键值存储非常简单方便，但它有一些限制：

// 只能使用原始类型: int，double，bool，string 和 string list。
// 它不是用来存储大量数据，因此不适合作为应用程序缓存。

// shared_preferences 实例常用方法：
// get/setInt(key) - 查询或设置整型键。
// get/setBool(key) - 查询或设置布尔键。
// get/setDouble(key) - 查询或设置浮点键。
// get/setString(key) - 查询或设置字符串键。
// get/setStringList(key) - 查询或设置字符串列表键。
// getKeys() - 获取所有键值名。
// remove(key) - 删除某个键内容。
// clear() - 清除全部内容。

class SharedPreferencesUtils {
  //获取数据
  static getData(String key) async {
    // 获取实例
    var prefs = await SharedPreferences.getInstance();
    // 获取存储数据
    var value = prefs.get(key);
    // var value = prefs.getString(key) ??
    //     prefs.getInt(key) ??
    //     prefs.getDouble(key) ??
    //     prefs.getBool(key) ??
    //     prefs.getStringList(key) ??
    //     null;
    return value;
  }

  //获取数据
  static setData(String key, var value) async {
    // 获取实例
    var prefs = await SharedPreferences.getInstance();
    // 设置存储数据
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
    return true;
  }

  //删除数据
  static removeData(String key) async {
    // 获取实例
    var prefs = await SharedPreferences.getInstance();
    // 获取存储数据
    await prefs.remove(key);
    return true;
  }
}

//使用例子
// SharedPreferencesUtils.getData(key).then((value){
//   print(value);
// });
// SharedPreferencesUtils.setData(key, "value");