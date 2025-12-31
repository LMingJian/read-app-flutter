import 'dart:io';
import 'package:path_provider/path_provider.dart';

String _appLibraryDirectory = '';

class FileUtils {
  static init() async {
    _appLibraryDirectory = (await getApplicationDocumentsDirectory()).path;
  }

  static writeLibraryFile(String fileName, String data) {
    File file = File('$_appLibraryDirectory/$fileName');
    IOSink isk = file.openWrite(mode: FileMode.append);
    isk.write('$data\n');
    isk.close();
  }

  static readLibraryFile(String fileName) {
    File file = File('$_appLibraryDirectory/$fileName');
    if (file.existsSync()) {
      return file.readAsLinesSync();
    } else {
      return [];
    }
  }

  static removeLibraryFile(String fileName) {
    File file = File('$_appLibraryDirectory/$fileName');
    file.writeAsStringSync('');
  }
}
