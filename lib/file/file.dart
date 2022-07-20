import 'dart:io';
import 'package:path_provider/path_provider.dart';

const USER_DATA = _CacheFile("data.json");

const WORDS_FILE = _CacheFile("words.json");

const WORDS_ALPHABETICALLY_FILE = _CacheFile("words_alphabetically.json");

class _CacheFile {

  final String name;

  const _CacheFile(this.name);

  Future<File> get _localFile async {
    return File('${(await getApplicationDocumentsDirectory()).path}/$name').create();
  }

  Future<String> read() async {
    try {
      return await (await _localFile).readAsString();
    } catch (e) {
      return e.toString();
    }
  }

  void write(String content) async {
    (await _localFile).writeAsString(content);
  }
}