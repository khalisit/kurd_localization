

<h1 align="center">Kurd Localization</h1>
<p align="center">
  <i>A professional Flutter localization package with comprehensive Kurdish language support</i>
</p>



<p align="center">
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#documentation">Documentation</a> •
</p>

---

## Overview

**Kurd Localization** is a production-ready localization package for Flutter applications, developed and maintained by **Khalis IT**. It provides comprehensive support for Kurdish languages (Kurmanji and Sorani) alongside standard multilingual capabilities.

Designed with enterprise applications in mind, this package offers a flexible architecture that seamlessly integrates with Flutter's localization system while providing powerful features like dynamic translations, pluralization, gender-specific translations, and translation verification tools.

---

## Features

### 🌍 Multilingual Support
- **Kurdish Kurmanji** (krm) - Full Material & Cupertino localization
- **Kurdish Sorani** (ckb) - Full Material & Cupertino localization  
- **RTL Support** - Automatic right-to-left text direction for Arabic and Kurdish
- **Fallback Locale** - Graceful degradation when translations are missing

### ✨ Developer Experience
- **Easy Translation Extensions** - Use `.tr()` on Strings and Text widgets without context
- **BuildContext Extensions** - Convenient methods for accessing translations
- **JSON File Support** - Load translations from external JSON files
- **Inline Map Support** - Define translations directly in Dart code

### 🎯 Advanced Features
- **Pluralization** - Language-specific plural rules (zero, one, two, few, many, other)
- **Gender-Specific Translations** - Support for male, female, and neutral variations
- **Interpolation** - Insert dynamic values into translations (`Hello, {name}!`)
- **Translation Verification Tool** - CLI tool for validating translation keys

### 🔧 Integration
- **Flutter Native Compatibility** - Works seamlessly with `flutter_localizations`
- **MaterialApp & CupertinoApp** - Full support for both app types
- **Custom Loaders** - Extensible architecture for custom data sources

---

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  kurd_localization: ^1.0.3
  flutter_localizations:
    sdk: flutter
```

Then run:

```bash
flutter pub get
```

---

## Quick Start

### 1. Create Translation Files

Create a JSON file at `assets/languages/translations.json`:

```json
{
  "en": {
    "app_title": "My Application",
    "welcome_message": "Welcome, {name}!",
    "items_count": "You have {} items"
  },
  "krm": {
    "app_title": "Serenîşan",
    "welcome_message": "Bi xêr hatî, {name}!",
    "items_count": "Te {} hene"
  },
  "ckb": {
    "app_title": "پرۆگرام",
    "welcome_message": "بەخێربێیت، {name}!",
    "items_count": "تۆ {} هەیە"
  },
  "ar": {
    "app_title": "تطبيقي",
    "welcome_message": "مرحباً، {name}!",
    "items_count": "لديك {} عناصر"
  }
}
```

Add the asset directory to your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/languages/
```

### 2. Configure Localization

```dart
import 'package:kurd_localization/kurd_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kurd Localization Demo',
      
      // Localization configuration
      localizationsDelegates: [
        KurdLocalizationDelegate.fromLoader(
          Loaders.json(path: 'assets/languages/translations.json'),
          fallbackLocale: const Locale('en'),
        ),
        ...kurdishLocalizations,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      
      supportedLocales: const [
        Locale('en'),  // English
        Locale('krm'), // Kurdish Kurmanji
        Locale('ckb'), // Kurdish Sorani
        Locale('ar'),  // Arabic
      ],
      
      locale: const Locale('en'),
      home: const HomePage(),
    );
  }
}
```

### 3. Use Translations

#### Method 1: String Extension (Recommended)

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple translation
            Text('welcome_message'.tr(args: {'name': 'Khalis'})),
            
            // Pluralization
            Text('items_count'.plural(itemCount)),
            
            // Check current language
            if (context.isKurdish)
              const Text('Kurdish language active!'),
          ],
        ),
      ),
    );
  }
}
```

#### Method 2: BuildContext Extension

```dart
Text(context.translate('app_title'))
Text(context.translate('welcome_message', args: {'name': 'Khalis'}))
Text(context.plural('items_count', 5))
```

#### Method 3: Direct Instance Access

```dart
final localizer = KurdLocalization.of(context);
Text(localizer.translate('app_title'))
```

---

## Documentation

### 📚 Translation Loaders

The package supports multiple ways to load translations:

#### JSON Asset Loader
```dart
KurdLocalizationDelegate.fromLoader(
  Loaders.json(path: 'assets/languages/translations.json'),
  fallbackLocale: const Locale('en'),
)
```

#### Direct Map
```dart
final translations = {
  'en': {'hello': 'Hello'},
  'krm': {'hello': 'Silav'},
};

KurdLocalizationDelegate.fromMap(
  translations,
  fallbackLocale: const Locale('en'),
)
```

For detailed loader documentation, see [loader.md](https://github.com/khalisit/kurd_localization/loader.md)

### 🔤 Pluralization

Handle plural forms with language-specific rules:

```json
{
  "item": {
    "zero": "No items",
    "one": "1 item",
    "two": "2 items",
    "few": "{} items",
    "many": "{} items",
    "other": "{} items"
  }
}
```

```dart
Text('item').plural(0)  // No items
Text('item').plural(1)  // 1 item
Text('item').plural(5)  // 5 items
```

### ⚧ Gender-Specific Translations

```json
{
  "greeting": {
    "male": "Welcome, sir",
    "female": "Welcome, madam",
    "other": "Welcome"
  }
}
```

```dart
Text('greeting').tr(gender: 'male')
```

### 🛡️ Fallback Locale

Automatically use a default language when translations are missing:

```dart
KurdLocalizationDelegate.fromLoader(
  Loaders.json(path: 'assets/languages/translations.json'),
  fallbackLocale: const Locale('en'), // Falls back to English
)
```

### ✅ Translation Verification Tool

Validate your translation files using the CLI tool:

```bash
# Verify all translations
dart run kurd_localization:verify_translations verify assets/languages

# Verify with reference locale
dart run kurd_localization:verify_translations verify assets/languages --reference en

# Compare two files
dart run kurd_localization:verify_translations compare assets/languages/en.json assets/languages/krm.json

# Find duplicates
dart run kurd_localization:verify_translations duplicates assets/languages/en.json
```


## Available Extensions

### String Extensions
```dart
'key'.tr()                                          // Simple translation
'key'.tr(args: {'name': 'value'})                   // With arguments
'key'.tr(gender: 'male')                            // Gender-specific
'key'.tr(locale: Locale('en'))                      // Specific locale
'key'.plural(count)                                 // Plural form
'key'.plural(count, args: {'name': 'value'})        // Plural with arguments
```

### Text Widget Extensions
```dart
Text('key').tr()                                    // Simple translation
Text('key').tr(args: {'name': 'value'})             // With arguments
Text('key').tr(gender: 'male')                      // Gender-specific
Text('key').plural(count)                           // Plural form
```

### BuildContext Extensions
```dart
context.translate('key')                            // Translate
context.translate('key', args: {...})               // With arguments
context.plural('key', count)                        // Plural
context.localization                                // KurdLocalization instance
context.currentLocale                               // Current Locale
context.languageCode                                // Language code
context.isKurdish                                   // Is Kurdish (any)
context.isKurdishSorani                             // Is Kurdish Sorani
context.isKurdishKurmanji                           // Is Kurdish Kurmanji
context.isArabic                                    // Is Arabic
context.isEnglish                                   // Is English
context.isRTL                                       // Is RTL language
context.textDirection                               // TextDirection
```

---

## Example Project

A complete example application is available in the [`/example`](https://github.com/khalisit/kurd_localization/example) directory.

To run the example:

```bash
cd example
flutter pub get
flutter run
```

---

## Kurdish Language Support

This package provides native localization for:

| Feature | Kurmanji (krm) | Sorani (ckb) |
|---------|---------------|--------------|
| Material Widgets | ✅ | ✅ |
| Cupertino Widgets | ✅ | ✅ |
| Text Direction | LTR | RTL |
| Date Formatting | ✅ | ✅ |
| Number Formatting | ✅ | ✅ |

### Supported Kurdish Scripts

- **Kurmanji Latin Script** - Standard Latin alphabet used in Northern Kurdistan
- **Sorani Arabic Script** - Arabic-based script used in Eastern Kurdistan

---

## Changelog

See [CHANGELOG.md](https://github.com/khalisit/kurd_localization/CHANGELOG.md) for version history and updates.

---

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## Support & Community

- 📱 **WhatsApp**: +964 780 895 4112
- 📖 **Documentation**: [Full Documentation](https://github.com/khalisit/kurd_localization)
- 👨‍💻 **GitHub**: [github.com/khalisit](https://github.com/khalisit)

---

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/khalisit/kurd_localization/LICENSE) file for details.

---

## About Khalis IT

**Khalis IT** is a software development company specializing in Flutter applications and localization solutions for the Kurdish market and the Middle East region.

We are committed to:
- 🔤 **Language Preservation** - Supporting Kurdish and regional languages in technology
- 🚀 **Quality Software** - Delivering production-ready, maintainable code
- 🌐 **Global Reach** - Helping businesses reach diverse audiences
- 🤝 **Community Support** - Providing resources and tools for developers

### Our Services

- Flutter Application Development
- Localization & Internationalization Consulting
- Custom Software Solutions
- Technical Training & Mentorship

### Connect With Us

- 📱 **WhatsApp**: +964 780 895 4112
- 👨‍💻 **GitHub**: [github.com/khalisit](https://github.com/khalisit)
- 📧 **Email**: khlskhalil@gmail.com

---

## Acknowledgments

This package was originally created by **Dosty Pshtiwan** and has been rebuilt and maintained by **Khalis IT**. We honor the original work and continue to improve upon this foundation.

**Original Developer**: Dosty Pshtiwan  
**Rebuilt & Maintained by**: Khalis IT

Additional acknowledgments:
- The Flutter team for the excellent localization framework
- Contributors to Kurdish language support in Flutter
- The community for feedback and improvements

---

<div align="center">

**Originally Developed by Dosty Pshtiwan**

**Rebuilt & Maintained by Khalis IT**

*Empowering Kurdish language in digital applications*

[⬆ Back to Top](#)

</div>
