import '../kurd_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KurdLocalization {
  static KurdLocalization? _instance;

  static KurdLocalization? get instance => _instance;

  final Locale locale;

  final Map<String, Map<String, dynamic>> translations;

  final Locale? fallbackLocale;

  KurdLocalization(
    this.locale,
    this.translations, {
    this.fallbackLocale,
  });

  String translate(String key,
      {Map<String, String>? args, String? gender, Locale? locale}) {
    final languageCode = locale?.languageCode ?? this.locale.languageCode;

    dynamic translation = translations[languageCode]?[key];

    if (translation == null && fallbackLocale != null) {
      translation = translations[fallbackLocale!.languageCode]?[key];
    }

    if (translation == null) {
      return '[$key]';
    }

    if (gender != null && translation is Map) {
      final genderKey = gender.toLowerCase();
      translation = translation[genderKey] ?? translation['other'] ?? '[$key]';
    }

    String translatedText = translation.toString();

    if (args != null) {
      args.forEach((placeholder, value) {
        translatedText = translatedText.replaceAll('{$placeholder}', value);
      });
    }

    return translatedText;
  }

  String plural(String key, num count,
      {Map<String, String>? args, Locale? locale}) {
    final languageCode = locale?.languageCode ?? this.locale.languageCode;

    dynamic translation = translations[languageCode]?[key];

    if (translation == null && fallbackLocale != null) {
      translation = translations[fallbackLocale!.languageCode]?[key];
    }

    if (translation == null) {
      return '[$key]';
    }

    if (translation is! Map) {
      return translation.toString();
    }

    final pluralForm = _getPluralForm(count, languageCode);

    String? pluralText;
    for (var form in pluralForm) {
      pluralText = translation[form]?.toString();
      if (pluralText != null) break;
    }

    pluralText ??= translation['other']?.toString() ?? '[$key]';

    pluralText = pluralText.replaceAll('{}', count.toString());

    if (args != null) {
      args.forEach((placeholder, value) {
        pluralText = pluralText!.replaceAll('{$placeholder}', value);
      });
    }

    return pluralText ?? '[$key]';
  }

  List<String> _getPluralForm(num count, String languageCode) {
    final n = count.abs();

    if (n == 0) {
      return ['zero', 'other'];
    }

    if (n == 1) {
      return ['one', 'other'];
    }

    if (n == 2) {
      return ['two', 'other'];
    }

    switch (languageCode) {
      case 'ru':
      case 'uk':
        final mod10 = n % 10;
        final mod100 = n % 100;

        if (mod10 == 1 && mod100 != 11) {
          return ['one', 'other'];
        } else if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) {
          return ['few', 'other'];
        } else {
          return ['many', 'other'];
        }

      case 'ar':
        if (n == 0) {
          return ['zero', 'other'];
        } else if (n == 1) {
          return ['one', 'other'];
        } else if (n == 2) {
          return ['two', 'other'];
        } else if (n % 100 >= 3 && n % 100 <= 10) {
          return ['few', 'other'];
        } else if (n % 100 >= 11) {
          return ['many', 'other'];
        }
        return ['other'];

      case 'pl':
        final mod10 = n % 10;
        final mod100 = n % 100;

        if (n == 1) {
          return ['one', 'other'];
        } else if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
          return ['few', 'other'];
        } else {
          return ['many', 'other'];
        }

      default:
        if (n == 1) {
          return ['one', 'other'];
        } else {
          return ['many', 'other'];
        }
    }
  }

  static KurdLocalization of(BuildContext context) {
    return Localizations.of<KurdLocalization>(context, KurdLocalization)!;
  }
}

class KurdLocalizationDelegate extends LocalizationsDelegate<KurdLocalization> {
  final Map<String, Map<String, dynamic>>? translations;

  final TranslationLoader? loader;

  final Locale? fallbackLocale;

  KurdLocalizationDelegate({
    this.translations,
    this.loader,
    this.fallbackLocale,
  }) : assert(
          translations != null || loader != null,
          'Either translations or loader must be provided',
        );

  factory KurdLocalizationDelegate.fromLoader(
    TranslationLoader loader, {
    Locale? fallbackLocale,
  }) {
    return KurdLocalizationDelegate(
      loader: loader,
      fallbackLocale: fallbackLocale,
    );
  }

  factory KurdLocalizationDelegate.fromJson(JsonAssetLoader loader) {
    return KurdLocalizationDelegate(loader: loader);
  }

  factory KurdLocalizationDelegate.fromMap(
    Map<String, Map<String, Object>> translations, {
    Locale? fallbackLocale,
  }) {
    return KurdLocalizationDelegate(
      translations: translations,
      fallbackLocale: fallbackLocale,
    );
  }

  Map<String, Map<String, Object>>? _loadedTranslations;

  @override
  bool isSupported(Locale locale) {
    if (translations != null) {
      return translations!.containsKey(locale.languageCode);
    }
    return true;
  }

  @override
  Future<KurdLocalization> load(Locale locale) async {
    if (loader != null && _loadedTranslations == null) {
      _loadedTranslations = await loader!.load();
    }

    final translationsMap = _loadedTranslations ?? translations!;
    final localization = KurdLocalization(
      locale,
      translationsMap,
      fallbackLocale: fallbackLocale,
    );

    KurdLocalization._instance = localization;

    return localization;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<KurdLocalization> old) =>
      false;
}

List<LocalizationsDelegate> get kurdishLocalizations => [
      KurdishMaterialLocalizations.delegate,
      KurdishWidgetLocalizations.delegate,
      KurdishCupertinoLocalizations.delegate,
      KurmanjiMaterialLocalizations.delegate,
      KurmanjiWidgetLocalizations.delegate,
      KurmanjiCupertinoLocalizations.delegate,
    ];

List<LocalizationsDelegate> get kurdishSoraniLocalizations => [
      KurdishMaterialLocalizations.delegate,
      KurdishWidgetLocalizations.delegate,
      KurdishCupertinoLocalizations.delegate,
    ];

List<LocalizationsDelegate> get kurmanjiLocalizations => [
      KurmanjiMaterialLocalizations.delegate,
      KurmanjiWidgetLocalizations.delegate,
      KurmanjiCupertinoLocalizations.delegate,
    ];

extension LocalizationExtension on BuildContext {
  KurdLocalization get localization => KurdLocalization.of(this);

  String translate(String key,
      {Map<String, String>? args, String? gender, Locale? locale}) {
    return KurdLocalization.of(this)
        .translate(key, args: args, gender: gender, locale: locale);
  }

  String plural(String key, num count,
      {Map<String, String>? args, Locale? locale}) {
    return KurdLocalization.of(this)
        .plural(key, count, args: args, locale: locale);
  }

  Locale get currentLocale => KurdLocalization.of(this).locale;

  String get languageCode => KurdLocalization.of(this).locale.languageCode;

  bool get isKurdish => languageCode == 'ckb' || languageCode == 'krm';

  bool get isKurdishSorani => languageCode == 'ckb';

  bool get isKurdishKurmanji => languageCode == 'krm';

  bool get isArabic => languageCode == 'ar';

  bool get isEnglish => languageCode == 'en';

  bool get isRTL => languageCode == 'ar' || languageCode == 'ckb';

  TextDirection get textDirection =>
      isRTL ? TextDirection.rtl : TextDirection.ltr;
}

extension StringTranslationExtension on String {
  String tr(
      {Map<String, String>? args,
      String? gender,
      Locale? locale,
      BuildContext? context}) {
    final localization = context != null
        ? KurdLocalization.of(context)
        : KurdLocalization.instance;

    if (localization == null) {
      throw Exception('KurdLocalization instance not found. '
          'Make sure KurdLocalizationDelegate is added to MaterialApp.localizationsDelegates');
    }

    return localization.translate(this,
        args: args, gender: gender, locale: locale);
  }

  String plural(num count,
      {Map<String, String>? args, Locale? locale, BuildContext? context}) {
    final localization = context != null
        ? KurdLocalization.of(context)
        : KurdLocalization.instance;

    if (localization == null) {
      throw Exception('KurdLocalization instance not found. '
          'Make sure KurdLocalizationDelegate is added to MaterialApp.localizationsDelegates');
    }

    return localization.plural(this, count, args: args, locale: locale);
  }
}

extension TextTranslationExtension on Text {
  Widget tr(
      {Map<String, String>? args,
      String? gender,
      Locale? locale,
      BuildContext? context}) {
    if (context == null) {
      return Builder(
        builder: (BuildContext ctx) {
          final localization = KurdLocalization.of(ctx);
          final translatedText = localization.translate(
            data ?? '',
            args: args,
            gender: gender,
            locale: locale,
          );

          return Text(
            translatedText,
            key: key,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: this.locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaler: textScaler,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
            selectionColor: selectionColor,
            semanticsIdentifier: semanticsIdentifier,
          );
        },
      );
    }

    final localization = KurdLocalization.of(context);
    final translatedText = localization.translate(
      data ?? '',
      args: args,
      gender: gender,
      locale: locale,
    );

    return Text(
      translatedText,
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: this.locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      semanticsIdentifier: semanticsIdentifier,
    );
  }

  Widget translate(
      {Map<String, String>? args,
      String? gender,
      Locale? locale,
      BuildContext? context}) {
    return tr(args: args, context: context, gender: gender, locale: locale);
  }

  Widget plural(num count,
      {Map<String, String>? args, Locale? locale, BuildContext? context}) {
    if (context == null) {
      return Builder(
        builder: (BuildContext ctx) {
          final localization = KurdLocalization.of(ctx);
          final translatedText = localization.plural(
            data ?? '',
            count,
            args: args,
            locale: locale,
          );

          return Text(
            translatedText,
            key: key,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: this.locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaler: textScaler,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
            selectionColor: selectionColor,
            semanticsIdentifier: semanticsIdentifier,
          );
        },
      );
    }

    final localization = KurdLocalization.of(context);
    final translatedText = localization.plural(
      data ?? '',
      count,
      args: args,
      locale: locale,
    );

    return Text(
      translatedText,
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: this.locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      semanticsIdentifier: semanticsIdentifier,
    );
  }
}
