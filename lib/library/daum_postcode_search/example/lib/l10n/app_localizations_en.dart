// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Daum Postcode Search Example';

  @override
  String get webviewSelection => 'Select WebView Library';

  @override
  String get webviewFlutterButtonLabel => 'Search with webview_flutter';

  @override
  String get webviewFlutterDescription => 'Official Flutter WebView plugin';

  @override
  String get inappWebviewButtonLabel => 'Search with flutter_inappwebview';

  @override
  String get inappWebviewDescription =>
      'Third-party WebView with advanced features';

  @override
  String get searchResults => 'Address Search Results';

  @override
  String get koreanAddress => 'Korean Address';

  @override
  String get englishAddress => 'English Address';

  @override
  String get zipcode => 'Zipcode';

  @override
  String get jibunAddress => 'Jibun Address';

  @override
  String get jibunAddressEnglish => 'Jibun Address (English)';

  @override
  String get searchButtonLabel => 'Search Address';

  @override
  String parsingError(Object error) {
    return 'Data parsing error: $error';
  }

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get searchPageTitle => 'Address Search';

  @override
  String get searchPageTitleWebViewFlutter =>
      'Address Search (webview_flutter)';

  @override
  String get searchPageTitleInAppWebView =>
      'Address Search (flutter_inappwebview)';

  @override
  String get refresh => 'Refresh';
}
