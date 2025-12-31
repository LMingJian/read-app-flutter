# 小说爬取 App

@LM 2021-5-1

## 介绍

由 `Flutter+Dart` 实现的网络小说爬取 App，拥有简单的搜索，阅读功能，能对阅读历史进行记录。

- 2022-08-14 重构：Flutter > 3.0
- 2022-09-07 修复加载失败时加载动画不消失的问题，添加注释
- **2025-12-31 该项目现仅做参考，已经无法使用了，但界面 UI 这部分还是可以的，只是没有重新对接书源**。

## 图示

![alt text](images/image-0.png)

![alt text](images/image-1.png)

![alt text](images/image-2.png)

# 打包

```shell
flutter build apk --release --target-platform android-arm
```
