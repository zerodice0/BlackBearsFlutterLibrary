# Daum 우편번호 검색 예제

이 예제는 `daum_postcode_search` 패키지를 다양한 WebView 구현과 통합하는 방법을 보여줍니다.

## 기능

- ✅ **이중 WebView 통합**: webview_flutter와 flutter_inappwebview 중 선택
- ✅ **다국어 지원**: 영문과 한글 자동 선택 및 폴백
- ✅ **오류 처리**: 포괄적인 오류 처리 및 복구
- ✅ **현대적 UI**: Material 3 디자인 및 반응형 레이아웃

## 예제 실행

```bash
flutter pub get
flutter run
```

## WebView 구현 방식

### 옵션 1: webview_flutter (공식)

파일: [lib/postcode_search_webview_flutter.dart](./lib/postcode_search_webview_flutter.dart)

**특징:**
- 공식 Flutter WebView 플러그인
- PostMessage 콜백 메커니즘
- 더 간단한 API

**핵심 코드:**
```dart
// JavaScript Channel 설정
_controller.addJavaScriptChannel(
  'DaumPostcodeChannel',
  onMessageReceived: (JavaScriptMessage message) {
    final result = DaumPostcodeCallbackParser.fromPostMessage(message.message);
    // 결과 처리...
  },
);

// HTML 로드
_controller.loadRequest(
  Uri.parse('${_server.url}/${DaumPostcodeAssets.postMessage}')
);
```

### 옵션 2: flutter_inappwebview (고급)

파일: [lib/postcode_search_inappwebview.dart](./lib/postcode_search_inappwebview.dart)

**특징:**
- 고급 WebView 기능
- JavaScript Handler 메커니즘
- 더 많은 제어 및 커스터마이제이션

**핵심 코드:**
```dart
// JavaScript Handler 설정
controller.addJavaScriptHandler(
  handlerName: 'handleAddressData',
  callback: (args) {
    final result = DaumPostcodeCallbackParser.fromJsHandler(args[0]);
    // 결과 처리...
  },
);

// HTML 로드
InAppWebView(
  initialUrlRequest: URLRequest(
    url: WebUri('${_server.url}/${DaumPostcodeAssets.jsHandler}')
  ),
)
```

## 다국어 지원

### 지원 언어
- 영문 (en)
- 한글 (ko)

### 자동 폴백

앱에는 지원되지 않는 언어에 대한 폴백 로직이 포함되어 있습니다:

```dart
localeResolutionCallback: (locale, supportedLocales) {
  if (locale != null) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
  }
  // 지원되지 않는 언어는 영문으로 폴백
  return supportedLocales.first;
},
```

**동작:**
- 🇺🇸 영어 시스템 → 영문 UI
- 🇰🇷 한국어 시스템 → 한글 UI
- 🇮🇹 이탈리아어 시스템 → 영문 UI (폴백)
- 🇫🇷 프랑스어 시스템 → 영문 UI (폴백)

### 새로운 언어 추가

1. ARB 파일 생성: `lib/l10n/app_{locale}.arb`
2. `app_en.arb`의 모든 문자열 번역
3. `flutter pub get` 실행

## 프로젝트 구조

```
example/
├── lib/
│   ├── main.dart                              # 앱 진입점
│   ├── postcode_search_webview_flutter.dart   # webview_flutter 구현
│   ├── postcode_search_inappwebview.dart      # flutter_inappwebview 구현
│   └── l10n/
│       ├── app_en.arb                         # 영문 번역
│       └── app_ko.arb                         # 한글 번역
├── l10n.yaml                                  # 국제화 설정
└── pubspec.yaml
```

## 라이센스

MIT 라이센스 - 자세한 내용은 [LICENSE](../LICENSE)를 참고하세요.
