import 'package:read_app/utils/shared_preferences_utils.dart';

class Rule {
  // 标题、链接匹配规则
  late String title, link, flagPage, rePage;
  late Map? replace;
  late bool ifPage;

  Rule({
    this.title = '',
    this.link = '',
    this.replace,
    this.ifPage = false,
    this.flagPage = '',
    this.rePage = '',
  });
}

class Source {
  // https://github.com/XIU2/Yuedu
  late String type; // Web or Api
  /*
  Web 支持规则：
  1.网站能使用GET、POST搜索，搜索参数为最多2个，搜索内容与分页参数
  2.搜索内容必须能以<a href="www.example.com/111/222"></a>链接标签被定位到
  3.目录内容必须能以<a></a>链接标签被定位到，支持替换链接中部分字符
  4.正文内容必须能以文本被定位到，内容必须在界面加载后就加载，不通过js加载
  5.正文内容支持分页，分页要求定位到下一页的链接，并给予正则匹配下一页与本页是否为同一章
  6.正文内容支持替换字符
   */
  late int id;
  late String bookSourceName,
      bookSourceUrl,
      bookSearchMethod,
      bookSearchUrl,
      bookSearchKey,
      bookSearchPage;
  late Rule searchRule, catalogRule, contentRule;
  Source(
    this.id,
    this.type,
    this.bookSourceName,
    this.bookSourceUrl,
    this.bookSearchMethod,
    this.bookSearchUrl,
    this.bookSearchKey,
    this.bookSearchPage,
    this.searchRule,
    this.catalogRule,
    this.contentRule,
  );
}

class BookSource {
  static int currentSource = 0;
  static List<Source> sourceList = [];

  static void init() {
    SharedPreferencesUtils.getData("currentSource").then((value) {
      if (value != null) {
        currentSource = value;
      }
    });
  }

  static void setCurrentSource(int id) {
    currentSource = id;
    SharedPreferencesUtils.setData("currentSource", currentSource);
  }

  static String getType() {
    return sourceList[currentSource].type;
  }

  static String getSourceUrl() {
    return sourceList[currentSource].bookSourceUrl;
  }

  static String getSourceName() {
    return sourceList[currentSource].bookSourceName;
  }

  static String getSearchMethod() {
    return sourceList[currentSource].bookSearchMethod;
  }

  static String getSearchUrl() {
    return sourceList[currentSource].bookSearchUrl;
  }

  static String getSearchKey() {
    return sourceList[currentSource].bookSearchKey;
  }

  static String getSearchPage() {
    return sourceList[currentSource].bookSearchPage;
  }

  static Rule getContentRule() {
    return sourceList[currentSource].contentRule;
  }

  static Rule getSearchRule() {
    return sourceList[currentSource].searchRule;
  }

  static Rule getCatalogRule() {
    return sourceList[currentSource].catalogRule;
  }
}
