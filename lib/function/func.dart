import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';
import 'package:read_app/api/api.dart';
import 'package:read_app/models/search_model.dart';
import 'package:read_app/utils/net_utils.dart';

class Func {
  ///搜索
  static search(String keyword, {int page = 1}) async {
    ///书源解析类型
    String type = BookSource.getType();

    ///结果
    List models = [];
    if (type == 'Web') {
      //参数
      String searchUrl = BookSource.getSearchUrl();
      String searchKey = BookSource.getSearchKey();
      String searchPage = BookSource.getSearchPage();
      String searchMethod = BookSource.getSearchMethod();
      String searchTitleRegExp = BookSource.getSearchRule().title;
      String searchLinkRegExp = BookSource.getSearchRule().link;
      String baseUrl = BookSource.getSourceUrl();
      Map<String, dynamic> params = {searchKey: keyword};
      dynamic document;

      //执行
      debugPrint('Search from $searchUrl');
      if (searchPage != '') {
        params.addAll({searchPage: page});
      }
      // 请求发送
      if (searchMethod == 'POST') {
        await NetUtils.post(
          searchUrl,
          params,
          success: (response) {
            document = parse(response);
          },
          fail: (exception) {
            debugPrint(exception.toString());
          },
        );
      } else if (searchMethod == 'GET') {
        await NetUtils.get(
          searchUrl,
          params: params,
          success: (response) {
            document = parse(response);
          },
          fail: (exception) {
            debugPrint(exception.toString());
          },
        );
      }
      if (document == null) {
        return models;
      }
      // 数据处理
      if (searchLinkRegExp == '') {
        dynamic tagA = document.body!.querySelectorAll(searchTitleRegExp);
        for (var each in tagA) {
          String? name = each.attributes['title'];
          name ??= each.text; // 当 ??= 左侧的值为空时,会将右侧变量的值赋值给左侧变量
          String url = each.attributes['href'];
          if (!RegExp(baseUrl).hasMatch(url)) {
            url = baseUrl + url;
          }
          models.add(SearchResultModel(name: name!, url: url));
        }
      } else {
        dynamic tagA = document.body!.querySelectorAll(searchTitleRegExp);
        dynamic tagB = document.body!.querySelectorAll(searchLinkRegExp);
        int flag = 0;
        for (var each in tagA) {
          String? name = each.attributes['title'];
          name ??= each.text;
          String url = tagB[flag].attributes['href'];
          if (!RegExp(baseUrl).hasMatch(url)) {
            url = baseUrl + url;
          }
          models.add(SearchResultModel(name: name!, url: url));
          flag++;
        }
      }
    } else if (type == 'Api') {}
    return models;
  }

  ///目录获取
  static index(String url) async {
    List models = [];
    Rule catalogRule = BookSource.getCatalogRule();
    String baseUrl = BookSource.getSourceUrl();
    if (catalogRule.replace != null) {
      catalogRule.replace!.forEach((dynamic key, dynamic value) {
        url = url.replaceAll(key, value);
      });
    }
    await NetUtils.get(
      url,
      success: (response) {
        var document = parse(response);
        if (catalogRule.link == '') {
          dynamic tagA = document.body!.querySelectorAll(catalogRule.title);
          for (var each in tagA) {
            String name = each.text;
            String url = each.attributes['href'];
            if (!RegExp(baseUrl).hasMatch(url)) {
              url = baseUrl + url;
            }
            models.add(IndexModel(name: name.trim(), url: url));
          }
        } else {
          dynamic tagA = document.body!.querySelectorAll(catalogRule.title);
          dynamic tagB = document.body!.querySelectorAll(catalogRule.link);
          int flag = 0;
          for (var each in tagA) {
            String name = each.attributes['title'];
            String url = tagB[flag].attributes['href'];
            if (!RegExp(baseUrl).hasMatch(url)) {
              url = baseUrl + url;
            }
            models.add(IndexModel(name: name.trim(), url: url));
            flag++;
          }
        }
      },
      fail: (exception) {
        debugPrint(exception.toString());
      },
    );
    return models;
  }

  ///正文获取
  static content(String url) async {
    List models = [];
    List nextContent = [];
    dynamic document;
    Rule contentRule = BookSource.getContentRule();
    String baseUrl = BookSource.getSourceUrl();
    await NetUtils.get(
      url,
      success: (response) {
        document = parse(response);
      },
      fail: (exception) {
        debugPrint(exception.toString());
      },
    );
    if (document == null) {
      return models;
    }
    if (contentRule.ifPage) {
      dynamic next = document.body!.querySelector(contentRule.flagPage);
      String nextUrl = next.attributes['href'];
      RegExp exp = RegExp(contentRule.rePage);
      if (exp.firstMatch(url)!.group(0) == exp.firstMatch(nextUrl)!.group(0)) {
        if (!RegExp(baseUrl).hasMatch(nextUrl)) {
          nextUrl = baseUrl + nextUrl;
        }
        nextContent = await Func.content(nextUrl);
      }
    }
    dynamic tagA = document.body!.querySelector(contentRule.title);
    String content = '';
    for (var each in tagA.nodes) {
      String text = each.text.trim();
      if (contentRule.replace != null) {
        contentRule.replace!.forEach((dynamic key, dynamic value) {
          text = text.replaceAll(key, value);
        });
      }
      if (text == '') {
        continue;
      }
      content = '${content + each.text.trim()}\n\n';
    }
    content = content.replaceAll(' ', '').trim();
    models.add(content);
    return models + nextContent;
  }
}
