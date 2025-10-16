# Daum Postcode Search Example

This example demonstrates how to integrate `daum_postcode_search` package with different WebView implementations.

## Features

- ✅ **Dual WebView Integration**: Choose between webview_flutter and flutter_inappwebview
- ✅ **Multi-language Support**: English and Korean with automatic fallback
- ✅ **Error Handling**: Comprehensive error handling and recovery
- ✅ **Modern UI**: Material 3 design with responsive layout

## Running the Example

```bash
flutter pub get
flutter run
```

## WebView Implementations

### Option 1: webview_flutter (Official)

File: [lib/postcode_search_webview_flutter.dart](./lib/postcode_search_webview_flutter.dart)

**Features:**
- Official Flutter WebView plugin
- PostMessage callback mechanism
- Simpler API

**Key Code:**
```dart
// Setup JavaScript Channel
_controller.addJavaScriptChannel(
  'DaumPostcodeChannel',
  onMessageReceived: (JavaScriptMessage message) {
    final result = DaumPostcodeCallbackParser.fromPostMessage(message.message);
    // Handle result...
  },
);

// Load HTML
_controller.loadRequest(
  Uri.parse('${_server.url}/${DaumPostcodeAssets.postMessage}')
);
```

### Option 2: flutter_inappwebview (Advanced)

File: [lib/postcode_search_inappwebview.dart](./lib/postcode_search_inappwebview.dart)

**Features:**
- Advanced WebView features
- JavaScript Handler mechanism
- More control and customization

**Key Code:**
```dart
// Setup JavaScript Handler
controller.addJavaScriptHandler(
  handlerName: 'handleAddressData',
  callback: (args) {
    final result = DaumPostcodeCallbackParser.fromJsHandler(args[0]);
    // Handle result...
  },
);

// Load HTML
InAppWebView(
  initialUrlRequest: URLRequest(
    url: WebUri('${_server.url}/${DaumPostcodeAssets.jsHandler}')
  ),
)
```

## Multi-language Support

### Supported Languages
- English (en)
- Korean (ko)

### Automatic Fallback

The app includes locale fallback for unsupported languages:

```dart
localeResolutionCallback: (locale, supportedLocales) {
  if (locale != null) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
  }
  // Fallback to English for unsupported languages
  return supportedLocales.first;
},
```

**Behavior:**
- 🇺🇸 English system → English UI
- 🇰🇷 Korean system → Korean UI
- 🇮🇹 Italian system → English UI (fallback)
- 🇫🇷 French system → English UI (fallback)

### Adding New Languages

1. Create ARB file: `lib/l10n/app_{locale}.arb`
2. Translate all strings from `app_en.arb`
3. Run `flutter pub get`

## Project Structure

```
example/
├── lib/
│   ├── main.dart                              # App entry point
│   ├── postcode_search_webview_flutter.dart   # webview_flutter implementation
│   ├── postcode_search_inappwebview.dart      # flutter_inappwebview implementation
│   └── l10n/
│       ├── app_en.arb                         # English translations
│       └── app_ko.arb                         # Korean translations
├── l10n.yaml                                  # Localization config
└── pubspec.yaml
```

## License

MIT License - see [LICENSE](../LICENSE) for details.
