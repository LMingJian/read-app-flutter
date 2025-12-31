import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';

class ZipUtils {
  static read(String filePath, String fileName) {
    // Read the Zip file from disk.
    final bytes = File(filePath).readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    // Read data
    final targetFile = archive.findFile(fileName);
    if (targetFile != null) {
      final byteData = targetFile.content as List<int>;
      String decoded = utf8.decode(byteData);
      return json.decode(decoded);
    } else {
      return null;
    }
  }

  /*
  static void example() {
    // Read the Zip file from disk.
    final bytes = File('test.zip').readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('out/' + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('out/' + filename).create(recursive: true);
      }
    }
  }
  */

}
