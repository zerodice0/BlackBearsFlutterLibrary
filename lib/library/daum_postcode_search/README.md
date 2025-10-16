[README-EN](https://github.com/zerodice0/BlackBearsFlutterLibrary/blob/main/lib/library/daum_postcode_search/README.md)

[README-KR](https://github.com/zerodice0/BlackBearsFlutterLibrary/blob/main/lib/library/daum_postcode_search/README.KR.md)

# DAUM Postcode Search Package

**Zero-dependency** Flutter package for integrating [DAUM Postcode Service](https://postcode.map.daum.net/guide). Provides local HTTP server and HTML assets - you choose your own WebView implementation (webview_flutter, flutter_inappwebview, or any other).

## Features

- **🎯 Zero dependencies**: No forced WebView package
- **📦 Lightweight**: ~50KB (98.5% smaller than v0.0.4)
- **🔧 Flexible**: Compatible with any WebView package
- **🌐 Multiple callback methods**: URL Scheme, PostMessage, JS Handler, JS Channel
- **🚀 Simple API**: Local server + HTML assets + callback parser

## Installation

```yaml
dependencies:
  daum_postcode_search: ^1.0.0

  # Choose your WebView implementation:
  webview_flutter: ^4.8.0  # Option 1: Official Flutter WebView
  # OR
  flutter_inappwebview: ^6.1.5  # Option 2: Advanced features
```

## Setup

### Android

Add `android:usesCleartextTraffic="true"` to your `<application>` in AndroidManifest.xml. Clear text traffic-related errors occur if you do not set permissions because some items in [DAUM postcode service](https://postcode.map.daum.net/guide) do not use SSL.

```xml
<application
    android:usesCleartextTraffic="true"
    ...>
</application>
```

### iOS

Add the following to your Info.plist to allow network access. Without this, you will only see a white screen.

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key><true/>
</dict>
```

## Migration from 0.0.4 to 1.0.0

### ⚠️ BREAKING CHANGES

Version 1.0.0 is a complete rewrite that removes `flutter_inappwebview` dependency. You now implement your own WebView integration.

### What Changed

**Removed:**
- ❌ `DaumPostcodeSearch` widget
- ❌ All WebView callbacks (`onConsoleMessage`, `onReceivedError`, etc.)
- ❌ `flutter_inappwebview` dependency (~3-4MB)

**Added:**
- ✅ `DaumPostcodeLocalServer` - Local HTTP server
- ✅ `DaumPostcodeCallbackParser` - Parse address data
- ✅ `DaumPostcodeAssets` - HTML file path constants
- ✅ 4 HTML versions with different callback mechanisms

### How to Migrate

#### Step 1: Update Dependencies

**Before (0.0.4):**
```yaml
dependencies:
  daum_postcode_search: ^0.0.4
```

**After (1.0.0):**
```yaml
dependencies:
  daum_postcode_search: ^1.0.0
  webview_flutter: ^4.8.0  # Add your chosen WebView
```

#### Step 2: Replace Widget

**Before (0.0.4):**
```dart
DaumPostcodeSearch(  // ❌ This widget no longer exists
  onConsoleMessage: (_, message) => print(message),
  onReceivedError: (controller, request, error) => setState(...),
)
```

**After (1.0.0) - Basic Pattern:**
```dart
import 'package:daum_postcode_search/daum_postcode_search.dart';

// 1. Create and start server
final server = DaumPostcodeLocalServer();
await server.start();

// 2. Load HTML in your WebView
final url = '${server.url}/${DaumPostcodeAssets.postMessage}';

// 3. Handle callback and parse data
final result = DaumPostcodeCallbackParser.fromPostMessage(data);
if (result != null) {
  print('Address: ${result.address}');
  print('Zipcode: ${result.zonecode}');
}

// 4. Stop server when done
await server.stop();
```

For complete implementation examples, see:
- **webview_flutter**: [example/lib/postcode_search_webview_flutter.dart](./example/lib/postcode_search_webview_flutter.dart)
- **flutter_inappwebview**: [example/lib/postcode_search_inappwebview.dart](./example/lib/postcode_search_inappwebview.dart)

### Why This Change?

**Benefits of 1.0.0:**
- ✅ **Freedom**: Choose any WebView package or switch freely
- ✅ **Smaller**: 98.5% size reduction (3-4MB → 50KB)
- ✅ **Flexibility**: Full control over WebView configuration
- ✅ **Future-proof**: Not locked into specific package versions
- ✅ **Modern**: Clean separation of concerns

**Migration effort:** ~15-30 minutes for typical integration

## Quick Start

### 1. Start Local Server

```dart
import 'package:daum_postcode_search/daum_postcode_search.dart';

final server = DaumPostcodeLocalServer();
await server.start();  // Defaults: localhost:8080
print(server.url);     // http://localhost:8080
```

### 2. Choose HTML Version

```dart
// Four callback mechanisms available:
DaumPostcodeAssets.urlScheme    // URL Scheme callback
DaumPostcodeAssets.postMessage  // PostMessage (for webview_flutter)
DaumPostcodeAssets.jsHandler    // JS Handler (for flutter_inappwebview)
DaumPostcodeAssets.jsChannel    // JS Channel
```

### 3. Integrate with Your WebView

**Option A: webview_flutter**
```dart
WebViewController()
  ..addJavaScriptChannel('DaumPostcodeChannel',
    onMessageReceived: (message) {
      final result = DaumPostcodeCallbackParser.fromPostMessage(message.message);
      // Use result...
    })
  ..loadRequest(Uri.parse('${server.url}/${DaumPostcodeAssets.postMessage}'));
```

**Option B: flutter_inappwebview**
```dart
InAppWebView(
  initialUrlRequest: URLRequest(
    url: WebUri('${server.url}/${DaumPostcodeAssets.jsHandler}')
  ),
  onWebViewCreated: (controller) {
    controller.addJavaScriptHandler(
      handlerName: 'handleAddressData',
      callback: (args) {
        final result = DaumPostcodeCallbackParser.fromJsHandler(args[0]);
        // Use result...
      },
    );
  },
)
```

**Complete examples**: See [example](./example) directory

## API Reference

### DaumPostcodeLocalServer

```dart
// Create and configure
final server = DaumPostcodeLocalServer(
  address: 'localhost',  // Default
  port: 8080,           // Default
);

// Lifecycle
await server.start();
bool isRunning = server.isRunning;
String url = server.url;
await server.stop();
```

### DaumPostcodeCallbackParser

```dart
// Parse from different callback types
DataModel? result = DaumPostcodeCallbackParser.fromPostMessage(json);
DataModel? result = DaumPostcodeCallbackParser.fromJsHandler(data);
DataModel? result = DaumPostcodeCallbackParser.fromUrlScheme(url);
```

### DaumPostcodeAssets

```dart
// HTML file paths (use with server.url)
DaumPostcodeAssets.urlScheme    // URL Scheme version
DaumPostcodeAssets.postMessage  // PostMessage version (recommended for webview_flutter)
DaumPostcodeAssets.jsHandler    // JS Handler version (recommended for flutter_inappwebview)
DaumPostcodeAssets.jsChannel    // JS Channel version
```

### DataModel Fields

All fields from [DAUM Postcode API](https://postcode.map.daum.net/guide):
- `address`, `addressEnglish` - Full address
- `zonecode` - 5-digit postal code
- `roadAddress`, `roadAddressEnglish` - Road name address
- `jibunAddress`, `jibunAddressEnglish` - Land-lot address
- [See full list](./lib/src/data_model.dart)

## Example

The [example app](./example) demonstrates:
- ✅ Dual WebView support (webview_flutter + flutter_inappwebview)
- ✅ Multi-language UI (English, Korean)
- ✅ Complete error handling
- ✅ Modern Material 3 design

Run the example:
```bash
cd example
flutter pub get
flutter run
```

See [example/README.md](./example/README.md) for details.

## License

This project is licensed under the MIT License - see the LICENSE file for details.