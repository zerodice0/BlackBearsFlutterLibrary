# Daum Postcode Search - AI Agent Guidelines

## Project Overview

**Daum Postcode Search** is a lightweight Flutter package that provides local server and HTML assets for integrating the [Daum Postcode Service](https://postcode.map.daum.net/guide) in Flutter applications. Users can choose their own WebView implementation for maximum flexibility.

### Key Features
- **Zero external dependencies**: Only Flutter SDK required (uses dart:io)
- Local HTTP server for serving HTML assets
- Three HTML versions for different callback methods
- Comprehensive address data model (30+ fields)
- Support for both Korean and English address formats
- Ultra-lightweight: ~50KB package size

### Current Version
- **Version**: 0.1.0
- **Flutter SDK**: >=3.6.1 <4.0.0
- **Dependencies**: None (only Flutter SDK)

## Architecture

### Core Architecture Pattern
The package uses a **Separation of Concerns** pattern:

**Package Provides:**
1. **Local HTTP Server**: `DaumPostcodeLocalServer` (dart:io based) serves HTML assets
2. **HTML Assets**: Three versions for different callback methods
3. **Data Model**: `DataModel` for address data
4. **Callback Parser**: `DaumPostcodeCallbackParser` for parsing results

**User Implements:**
1. **WebView**: Any WebView package (webview_flutter, flutter_inappwebview, etc.)
2. **Callback Handling**: URL navigation interception or JavaScript channels
3. **UI/UX**: Complete control over presentation

### Data Flow
```
User's WebView → Local Server (dart:io) → HTML Asset → Daum API (CDN)
                                                           ↓
                                                    Address Selected
                                                           ↓
JavaScript Callback → URL Scheme / PostMessage / JS Handler
                              ↓
User's NavigationDelegate → DaumPostcodeCallbackParser
                              ↓
                         DataModel → Navigator.pop()
```

### Key Technical Decisions

1. **Why dart:io?**: Zero external dependencies, part of Dart SDK
2. **Why No WebView?**: Maximum flexibility - users choose their preferred solution
3. **Why Three HTML Versions?**: Different WebView packages support different callback methods
4. **Why Local Server?**: Proper MIME types, CORS handling, and CDN resource loading

## Code Structure

### File Organization
```
lib/
├── daum_postcode_search.dart           # Package exports
├── src/
│   ├── local_server.dart               # Local HTTP server (dart:io)
│   ├── data_model.dart                 # Address data model
│   ├── callback_parser.dart            # Callback parsing utilities
│   └── constants.dart                  # Asset path constants
└── assets/
    ├── daum_search_urlscheme.html      # URL Scheme callback
    ├── daum_search_postmessage.html    # PostMessage callback
    └── daum_search_jshandler.html      # JavaScript Handler callback
```

### Component Responsibilities

#### `local_server.dart` - DaumPostcodeLocalServer
- Uses `dart:io` `HttpServer` for local serving
- Binds to localhost:8080 by default (configurable)
- Loads assets via `rootBundle`
- Auto-detects Content-Type based on file extension
- Manages server lifecycle (start/stop)

**Key Methods**:
- `Future<void> start()`: Starts the server
- `Future<void> stop()`: Stops the server
- `String get url`: Returns server URL
- `bool get isRunning`: Check if server is running

#### `callback_parser.dart` - DaumPostcodeCallbackParser
- Static utility class for parsing callbacks
- Three parsing methods for different callback types:
  - `fromUrlScheme()`: For URL scheme callbacks
  - `fromPostMessage()`: For PostMessage callbacks
  - `fromMap()`: For JavaScript Handler callbacks
- `isCallbackUrl()`: Check if URL is a callback URL

#### `data_model.dart` - DataModel Class
- **Immutable data class** with 33 fields
- Static factory method: `DataModel.fromMap(Map<String, dynamic>)`
- All fields are `required` but default to empty strings via null coalescing
- No toMap/toJson methods (one-way from web to Flutter)

**Critical Fields**:
- `zonecode`: 5-digit postal code (replaces deprecated postcode)
- `address`: Primary Korean address
- `addressEnglish`: English translation
- `roadAddress` / `jibunAddress`: Specific address types
- `autoJibunAddress`: Automatically selected jibun address

#### `daum_search.html` - Web Integration
- Loads Daum Postcode API v2 from CDN: `https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js`
- Embeds postcode widget in `#full-size` div
- Configuration:
  - `maxSuggestItems: 5`
  - `hideMapBtn: true` (hides map button)
  - `hideEngBtn: false` (shows English toggle)
  - `alwaysShowEngAddr: false`
- Calls `window.flutter_inappwebview.callHandler('onSelectAddress', data)` on completion

## Development Guidelines

### Coding Conventions

1. **Server Management**
   - Always start server in initState
   - Always stop server in dispose
   - Handle server start failures gracefully
   - Use `isRunning` to check server state

2. **Error Handling**
   - Catch server start exceptions
   - Handle asset loading failures
   - Provide user feedback for errors
   - Never suppress errors silently

3. **Naming Conventions**
   - Private fields: `_server`, `_controller`
   - Clear method names: `start()`, `stop()`, not `init()`, `destroy()`
   - Korean-friendly content in HTML
   - English code and documentation

4. **Dependencies**
   - **Zero external dependencies** - critical principle
   - Only use Flutter SDK and Dart SDK features
   - Never add external packages to this library
   - Users add their own WebView dependencies

5. **Asset Management**
   - HTML assets declared in `pubspec.yaml` under `flutter.assets`
   - Use `packages/` prefix: `packages/daum_postcode_search/assets/...`
   - Keep HTML minimal and focused
   - Load external resources (Daum API) from CDN

### Platform-Specific Requirements

#### Android
**Mandatory**: Add to `AndroidManifest.xml`:
```xml
<application
    android:usesCleartextTraffic="true"
    ...>
</application>
```
**Reason**: Some Daum API resources don't use SSL

**Minimum SDK**: 23 (Android 6.0)

#### iOS
**Mandatory**: Add to `Info.plist`:
```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key><true/>
</dict>
```
**Reason**: Allows HTTP connections to localhost server

### Testing Strategy

#### Manual Testing Checklist
1. **Basic Flow**
   - Widget loads and shows loading indicator
   - Search page appears after server starts
   - Address search returns results
   - Selection returns DataModel via Navigator.pop()

2. **Error Scenarios**
   - Network errors trigger `onReceivedError`
   - Reload button works via exposed controller
   - Console errors visible via `onConsoleMessage`

3. **Platform Testing**
   - Android: Clear text traffic enabled
   - iOS: ATS exceptions working
   - Both: Localhost server accessible

4. **Edge Cases**
   - Rapid back navigation (server cleanup)
   - Multiple widget instances
   - Device rotation
   - Background/foreground transitions

#### Test Files
- Currently in `test/` directory (verify and expand)
- Focus on DataModel.fromMap() with various input combinations
- Mock InAppWebView for widget testing

## Common Development Scenarios

### Adding New DataModel Fields

1. Identify new field from Daum API documentation
2. Add to DataModel constructor parameters
3. Add to `fromMap()` with null coalescing: `map["newField"] ?? ""`
4. Update README with new field documentation
5. Test with actual API responses

### Updating InAppWebView Version

1. Check InAppWebView changelog for breaking changes
2. Update `pubspec.yaml` version
3. Review deprecated APIs:
   - v5 → v6: `onLoadError` → `onReceivedError`
   - Check `InAppWebViewSettings` changes
4. Test on both platforms thoroughly
5. Update CHANGELOG.md with migration notes

### Customizing HTML/JavaScript

**File**: `lib/assets/daum_search.html`

**Safe Changes**:
- CSS styling in `<style>` block
- Daum Postcode configuration options
- Additional console logging

**Critical - Do Not Change**:
- JavaScript handler name: `'onSelectAddress'`
- Handler call structure: `window.flutter_inappwebview.callHandler(...)`
- Data passing: Must pass complete `data` object from Daum API

**Testing After Changes**:
1. Clear Flutter cache: `flutter clean`
2. Rebuild app
3. Verify data still flows correctly

### Adding Error Recovery Features

Pattern to follow (from widget.dart):
```dart
DaumPostcodeSearch daumPostcodeSearch = DaumPostcodeSearch(
  onReceivedError: (controller, request, error) {
    // Handle error
    setState(() {
      _isError = true;
      errorMessage = error.description;
    });
  },
);

// Access controller for retry
daumPostcodeSearch.controller?.reload();
```

### Localization Support

Current approach:
- Default Korean UI: `webPageTitle = "주소 검색"`
- Daum API handles language toggle internally
- DataModel includes both Korean and English fields

To add full localization:
1. Accept language parameter in widget constructor
2. Pass to HTML via URL parameters
3. Configure Daum API `language` option
4. Update default `webPageTitle` based on locale

## Common Issues and Solutions

### White Screen on iOS
**Cause**: Missing NSAppTransportSecurity in Info.plist
**Solution**: Add ATS exception (see Platform-Specific Requirements)

### Network Error on Android
**Cause**: Missing cleartext traffic permission
**Solution**: Add `android:usesCleartextTraffic="true"` to manifest

### JavaScript Handler Not Working
**Cause**: Handler registered before WebView fully initialized
**Solution**: Handler is registered in `onWebViewCreated` callback - ensure this pattern is maintained

### Server Already Running Error
**Cause**: Multiple instances or improper disposal
**Solution**: Ensure `dispose()` calls `localhostServer.close()` - already implemented correctly

### Asset Not Found Error
**Cause**: Asset path not declared in pubspec.yaml
**Solution**: Verify `flutter.assets` section includes HTML files

### Data Fields Empty
**Cause**: Daum API field names changed
**Solution**: Check Daum API documentation, update DataModel field mapping

## Migration Notes

### From 0.0.3 to 0.0.4
- InAppWebView 6.1.5 (from 6.0.x)
- Flutter SDK 3.6.1 minimum
- No breaking API changes

### From 0.0.2 to 0.0.3
- `onLoadError` and `onLoadHttpError` deprecated
- Use `onReceivedError` instead
- Update all example code

## Future Considerations

### Potential Enhancements
1. **Offline Support**: Cache common addresses
2. **Custom Styling**: Theme support for webview
3. **Filter Options**: Restrict search by region
4. **Multiple Results**: Return list instead of single selection
5. **Search History**: Recently searched addresses

### Technical Debt
1. `index.html` appears unused - consider removal
2. DataModel could use freezed/json_serializable for better codegen
3. No unit tests for widget lifecycle
4. Error messages not localized

### Breaking Change Considerations
If making breaking changes:
1. Bump to 0.1.0 or 1.0.0
2. Document migration path in CHANGELOG
3. Provide deprecation warnings for at least one version
4. Update all examples simultaneously

## Development Commands

### Running Example App
```bash
cd example
flutter pub get
flutter run
```

### Testing
```bash
flutter test
```

### Publishing Checklist
1. Update version in pubspec.yaml
2. Update CHANGELOG.md
3. Run `flutter pub publish --dry-run`
4. Fix any warnings
5. Test on example app (both platforms)
6. Commit changes
7. Create git tag: `git tag v0.0.4`
8. Run `flutter pub publish`

## Resources

### External Documentation
- [Daum Postcode Service Guide](https://postcode.map.daum.net/guide)
- [flutter_inappwebview Documentation](https://inappwebview.dev/)
- [Flutter Package Development](https://docs.flutter.dev/development/packages-and-plugins/developing-packages)

### Internal Documentation
- README.md: User-facing documentation
- README.KR.md: Korean user documentation
- CHANGELOG.md: Version history
- example/: Working implementation reference

## Contact & Contribution

**Repository**: https://github.com/zerodice0/BlackBearsFlutterLibrary
**Package Path**: /lib/library/daum_postcode_search

When contributing:
1. Follow existing code style
2. Test on both Android and iOS
3. Update documentation
4. Add CHANGELOG entry
5. Verify example app still works
