import 'json_loader.dart';
import 'translation_loader.dart';

class Loaders {
  static TranslationLoader json({
    required String path,
    List<String>? supportedLocales,
    bool useSingleFile = true,
  }) {
    return JsonAssetLoader(
      path: path,
      supportedLocales: supportedLocales,
      useSingleFile: useSingleFile,
    );
  }

  static TranslationLoader jsonString(String jsonString) {
    return JsonStringLoader(jsonString);
  }
}
