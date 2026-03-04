import 'dart:convert';
import 'package:flutter/services.dart';
import 'translation_loader.dart';

class JsonAssetLoader extends TranslationLoader {
  final String path;
  final List<String>? supportedLocales;
  final bool useSingleFile;

  JsonAssetLoader({
    required this.path,
    this.supportedLocales,
    this.useSingleFile = true,
  }) : assert(
          useSingleFile || supportedLocales != null,
          'supportedLocales must be provided when using multiple files',
        );

  @override
  Future<Map<String, Map<String, Object>>> load() async {
    if (useSingleFile) {
      return _loadSingleFile();
    } else {
      return _loadMultipleFiles();
    }
  }

  Future<Map<String, Map<String, Object>>> _loadSingleFile() async {
    final jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final Map<String, Map<String, Object>> translations = {};

    jsonMap.forEach((languageCode, translationsMap) {
      if (translationsMap is Map) {
        translations[languageCode] = Map<String, Object>.from(
          translationsMap.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        );
      }
    });

    return translations;
  }

  Future<Map<String, Map<String, Object>>> _loadMultipleFiles() async {
    final Map<String, Map<String, Object>> translations = {};

    for (final locale in supportedLocales!) {
      try {
        final filePath =
            path.endsWith('/') ? '$path$locale.json' : '$path/$locale.json';
        final jsonString = await rootBundle.loadString(filePath);
        final Map<String, dynamic> jsonMap = json.decode(jsonString);

        translations[locale] = Map<String, Object>.from(
          jsonMap.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        );
      } catch (_) {}
    }

    return translations;
  }
}

class JsonStringLoader extends TranslationLoader {
  final String jsonString;

  JsonStringLoader(this.jsonString);

  @override
  Future<Map<String, Map<String, Object>>> load() async {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final Map<String, Map<String, Object>> translations = {};

    jsonMap.forEach((languageCode, translationsMap) {
      if (translationsMap is Map) {
        translations[languageCode] = Map<String, Object>.from(
          translationsMap.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        );
      }
    });

    return translations;
  }
}
