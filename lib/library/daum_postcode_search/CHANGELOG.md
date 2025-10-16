## 0.1.0 - BREAKING CHANGES
- **Zero dependencies**: Removed `flutter_inappwebview` dependency
- **New architecture**: Package now provides only local server and HTML assets
- **User choice**: Users can now choose their own WebView implementation
- **New features**:
  - `DaumPostcodeLocalServer`: Local HTTP server using dart:io
  - `DaumPostcodeCallbackParser`: Utility for parsing callback data
  - `DaumPostcodeAssets`: Constants for different HTML versions
  - Three HTML versions: URL Scheme, PostMessage, JavaScript Handler
- **Breaking changes**:
  - Removed `DaumPostcodeSearch` widget
  - Removed all WebView-related callbacks
  - Users must implement their own WebView integration
- **Package size**: Reduced from ~3-4MB to ~50KB (98.5% reduction)
- See MIGRATION.md for migration guide from 0.0.4

## 0.0.4
- Migration to Flutter 3.6.1
- Migration to InAppWebView 6.1.5
- Update minSdkVersion to 23 on Android Example
