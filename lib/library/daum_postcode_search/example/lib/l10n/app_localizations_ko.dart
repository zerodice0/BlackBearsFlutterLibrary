// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Daum Postcode Search Example';

  @override
  String get webviewSelection => 'WebView 라이브러리 선택';

  @override
  String get webviewFlutterButtonLabel => 'webview_flutter로 검색';

  @override
  String get webviewFlutterDescription => 'Flutter 공식 WebView 플러그인';

  @override
  String get inappWebviewButtonLabel => 'flutter_inappwebview로 검색';

  @override
  String get inappWebviewDescription => '고급 기능을 제공하는 서드파티 WebView';

  @override
  String get searchResults => '주소 검색 결과';

  @override
  String get koreanAddress => '한글주소';

  @override
  String get englishAddress => '영문주소';

  @override
  String get zipcode => '우편번호';

  @override
  String get jibunAddress => '지번주소';

  @override
  String get jibunAddressEnglish => '지번주소(영문)';

  @override
  String get searchButtonLabel => '주소 검색';

  @override
  String parsingError(Object error) {
    return '데이터 파싱 오류: $error';
  }

  @override
  String get errorOccurred => '오류가 발생했습니다';

  @override
  String get retry => '다시 시도';

  @override
  String get searchPageTitle => '주소 검색';

  @override
  String get searchPageTitleWebViewFlutter => '주소 검색 (webview_flutter)';

  @override
  String get searchPageTitleInAppWebView => '주소 검색 (flutter_inappwebview)';

  @override
  String get refresh => 'Refresh';
}
