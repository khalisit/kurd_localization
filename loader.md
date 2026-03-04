# Translation Loaders Guide

This folder contains loaders for loading translations from JSON files.

## Available Loaders

### 1. JSON Loader (`json_loader.dart`)

Load translations from JSON files.

#### Single File Format:
```json
{
  "en": {
    "hello": "Hello",
    "world": "World",
    "welcome": "Welcome, {name}"
  },
  "ku": {
    "hello": "سڵاو",
    "world": "جیهان",
    "welcome": "بەخێربێی، {name}"
  }
}
```

#### Multiple Files Format:
```
assets/translations/
  ├── en.json
  ├── ckb.json
  ├── krm.json
  └── ar.json
```

**Usage:**
```dart
// Method 1: Using Loaders class (Recommended)
KurdLocalizationDelegate.fromLoader(
  Loaders.json(path: 'assets/translations.json')
)

// Method 2: Using factory method
KurdLocalizationDelegate.fromJson(
  JsonAssetLoader(path: 'assets/translations.json')
)

// Multiple files
KurdLocalizationDelegate.fromLoader(
  Loaders.json(
    path: 'assets/translations',
    supportedLocales: ['en', 'ku', 'ar'],
    useSingleFile: false,
  )
)

// From JSON string
KurdLocalizationDelegate.fromLoader(
  Loaders.jsonString('{"en": {"hello": "Hello"}, "ku": {"hello": "سڵاو"}}')
)
```

#### JSON Loader Parameters:

**For asset files:**
- `path` (required): Path to JSON file or folder
- `supportedLocales`: Required when `useSingleFile` is false
- `useSingleFile`: Whether to use single file format (default: true)

**For JSON strings:**
- `jsonString` (required): The JSON string containing translations

## Creating Custom Loaders

You can create your own loader by extending the `TranslationLoader` abstract class:

```dart
import 'package:best_localization/kurd_localization.dart';

class MyCustomLoader extends TranslationLoader {
  @override
  Future<Map<String, Map<String, String>>> load() async {
    // Your custom loading logic here
    return {
      'en': {'hello': 'Hello'},
      'ku': {'hello': 'سڵاو'},
    };
  }
}

// Usage
KurdLocalizationDelegate.fromLoader(MyCustomLoader())
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:best_localization/kurd_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Best Localization Demo',
      
      // Supported locales
      supportedLocales: [
        Locale('en'),
        Locale('ckb'),
        Locale('krm'),
        Locale('ar'),
      ],
      
      // Localization delegates
      localizationsDelegates: [
        // JSON loader
        KurdLocalizationDelegate.fromJson(
          JsonAssetLoader(path: 'assets/translations.json'),
        ),
        
        // Or using Loaders class with fallback
        KurdLocalizationDelegate.fromLoader(
          Loaders.json(
            path: 'assets/translations.json',
            fallbackLocale: Locale('en'),
          ),
        ),
        
        // Kurdish localizations
        ...kurdishLocalizations,
        
        // Default Flutter localizations
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate('app_title')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using extension method
            Text(context.translate('hello')),
            
            // With arguments
            Text(context.translate('welcome', args: {'name': 'John'})),
            
            // Check language
            if (context.isKurdishSorani)
              Text('Kurdish Sorani language detected'),
            if (context.isKurdishKurmanji)
              Text('Kurdish Kurmanji language detected'),
            
            // Get text direction
            Text(
              context.translate('some_text'),
              textDirection: context.textDirection,
            ),
          ],
        ),
      ),
    );
  }
}
```

## Don't Forget!

Add your translation files to `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/translations/
    # Or specific files
    - assets/translations/translations.json
    - assets/translations/en.json
    - assets/translations/ku.json
```

## Available Factory Methods

All loaders can be created using factory methods:

1. **`KurdLocalizationDelegate.fromMap()`** - Direct map
2. **`KurdLocalizationDelegate.fromJson()`** - JSON files
3. **`KurdLocalizationDelegate.fromLoader()`** - Generic loader (with Loaders class)

## Learn More

- **Fallback Locale**: See [FALLBACK.md](FALLBACK.md) for detailed examples and use cases
- **Main Documentation**: See [README.md](README.md)
