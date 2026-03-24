# DAUM 우편번호 검색 패키지

[README-EN](https://github.com/zerodice0/BlackBearsFlutterLibrary/blob/main/lib/library/daum_postcode_search/README.md)

**의존성 없는** Flutter 패키지로 [DAUM 우편번호 서비스](https://postcode.map.daum.net/guide)를 통합합니다. 로컬 HTTP 서버와 HTML 자산을 제공하며, WebView 구현은 사용자가 선택합니다 (webview_flutter, flutter_inappwebview 또는 기타).

## 주요 기능

- **🎯 의존성 없음**: 강제되는 WebView 패키지 없음
- **📦 가벼움**: ~50KB (v0.0.4 대비 98.5% 감소)
- **🔧 유연함**: 모든 WebView 패키지와 호환
- **🌐 다양한 콜백**: URL Scheme, PostMessage, JS Handler, JS Channel
- **🚀 간단한 API**: 로컬 서버 + HTML 자산 + 콜백 파서

## 설치

```yaml
dependencies:
  daum_postcode_search: ^1.1.0

  # WebView 구현 선택:
  webview_flutter: ^4.8.0  # 옵션 1: 공식 Flutter WebView
  # OR
  flutter_inappwebview: ^6.1.5  # 옵션 2: 고급 기능
```

## 설정

### Android

AndroidManifest.xml의 `<application>`에 `android:usesCleartextTraffic="true"`을 추가해주세요. [DAUM 우편번호 서비스](https://postcode.map.daum.net/guide) 내의 일부 항목이 SSL을 사용하지 않아서인지, 권한을 설정해주지 않으면 Clear text traffic 관련 에러가 발생합니다.

```xml
<application
    android:usesCleartextTraffic="true"
    ...>
</application>
```

> **참고:** 앱에서 `android:networkSecurityConfig`를 사용하는 경우, `usesCleartextTraffic` 속성은 무시됩니다. 이 경우 `network_security_config.xml`에 다음 도메인들을 추가해주세요:
>
> ```xml
> <?xml version="1.0" encoding="utf-8"?>
> <network-security-config>
>   <domain-config cleartextTrafficPermitted="true">
>     <domain includeSubdomains="true">localhost</domain>
>     <domain includeSubdomains="true">kakaocdn.net</domain>
>     <domain includeSubdomains="true">daum.net</domain>
>     <domain includeSubdomains="true">kakao.com</domain>
>   </domain-config>
> </network-security-config>
> ```

### iOS

Network 사용권한이 필요하므로 Info.plist에 아래의 내용을 추가해주세요. 추가하지 않을 경우에는 하얀 화면만 뜨게 됩니다.

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key><true/>
</dict>
```

## 0.0.4에서 1.0.0으로 마이그레이션

### ⚠️ 주요 변경사항

버전 1.0.0은 `flutter_inappwebview` 의존성을 제거한 완전한 재작성입니다. 이제 WebView 통합을 직접 구현합니다.

### 변경된 내용

**제거됨:**
- ❌ `DaumPostcodeSearch` 위젯
- ❌ 모든 WebView 콜백 (`onConsoleMessage`, `onReceivedError` 등)
- ❌ `flutter_inappwebview` 의존성 (~3-4MB)

**추가됨:**
- ✅ `DaumPostcodeLocalServer` - 로컬 HTTP 서버
- ✅ `DaumPostcodeCallbackParser` - 주소 데이터 파싱
- ✅ `DaumPostcodeAssets` - HTML 파일 경로 상수
- ✅ 4가지 콜백 메커니즘이 있는 HTML 버전

### 마이그레이션 방법

#### Step 1: 의존성 업데이트

**이전 (0.0.4):**
```yaml
dependencies:
  daum_postcode_search: ^0.0.4
```

**이후 (1.1.0):**
```yaml
dependencies:
  daum_postcode_search: ^1.1.0
  webview_flutter: ^4.8.0  # 선택한 WebView 추가
```

#### Step 2: 위젯 교체

**이전 (0.0.4):**
```dart
DaumPostcodeSearch(  // ❌ 이 위젯은 더 이상 존재하지 않습니다
  onConsoleMessage: (_, message) => print(message),
  onReceivedError: (controller, request, error) => setState(...),
)
```

**이후 (1.0.0) - 기본 패턴:**
```dart
import 'package:daum_postcode_search/daum_postcode_search.dart';

// 1. 서버 생성 및 시작
final server = DaumPostcodeLocalServer();
await server.start();

// 2. WebView에서 HTML 로드
final url = '${server.url}/${DaumPostcodeAssets.postMessage}';

// 3. 콜백 처리 및 데이터 파싱
final result = DaumPostcodeCallbackParser.fromPostMessage(data);
if (result != null) {
  print('주소: ${result.address}');
  print('우편번호: ${result.zonecode}');
}

// 4. 완료 후 서버 정지
await server.stop();
```

전체 구현 예제는 다음을 참고하세요:
- **webview_flutter**: [example/lib/postcode_search_webview_flutter.dart](./example/lib/postcode_search_webview_flutter.dart)
- **flutter_inappwebview**: [example/lib/postcode_search_inappwebview.dart](./example/lib/postcode_search_inappwebview.dart)

### 변경 이유

**1.0.0의 장점:**
- ✅ **자유도**: 모든 WebView 패키지 선택 가능 또는 자유롭게 변경
- ✅ **크기 감소**: 98.5% 감소 (3-4MB → 50KB)
- ✅ **유연성**: WebView 설정에 대한 완전한 제어
- ✅ **미래 대응**: 특정 패키지 버전에 종속되지 않음
- ✅ **현대적**: 깔끔한 관심사의 분리

**마이그레이션 시간:** 일반적인 통합에 대해 ~15-30분

## 빠른 시작

### 1. 로컬 서버 시작

```dart
import 'package:daum_postcode_search/daum_postcode_search.dart';

final server = DaumPostcodeLocalServer();
await server.start();  // 기본값: localhost:8080
print(server.url);     // http://localhost:8080
```

### 2. HTML 버전 선택

```dart
// 4가지 콜백 메커니즘 사용 가능:
DaumPostcodeAssets.urlScheme    // URL Scheme 콜백
DaumPostcodeAssets.postMessage  // PostMessage (webview_flutter용)
DaumPostcodeAssets.jsHandler    // JS Handler (flutter_inappwebview용)
DaumPostcodeAssets.jsChannel    // JS Channel
```

### 3. WebView와 통합

**옵션 A: webview_flutter**
```dart
WebViewController()
  ..addJavaScriptChannel('DaumPostcodeChannel',
    onMessageReceived: (message) {
      final result = DaumPostcodeCallbackParser.fromPostMessage(message.message);
      // 결과 사용...
    })
  ..loadRequest(Uri.parse('${server.url}/${DaumPostcodeAssets.postMessage}'));
```

**옵션 B: flutter_inappwebview**
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
        // 결과 사용...
      },
    );
  },
)
```

**전체 예제**: [example](./example) 디렉토리 참고

## API 참고

### DaumPostcodeLocalServer

```dart
// 생성 및 설정
final server = DaumPostcodeLocalServer(
  address: 'localhost',  // 기본값
  port: 8080,           // 기본값
);

// 라이프사이클
await server.start();
bool isRunning = server.isRunning;
String url = server.url;
await server.stop();
```

### DaumPostcodeCallbackParser

```dart
// 다양한 콜백 타입에서 파싱
DataModel? result = DaumPostcodeCallbackParser.fromPostMessage(json);
DataModel? result = DaumPostcodeCallbackParser.fromJsHandler(data);
DataModel? result = DaumPostcodeCallbackParser.fromUrlScheme(url);
```

### DaumPostcodeAssets

```dart
// HTML 파일 경로 (server.url과 함께 사용)
DaumPostcodeAssets.urlScheme    // URL Scheme 버전
DaumPostcodeAssets.postMessage  // PostMessage 버전 (webview_flutter 권장)
DaumPostcodeAssets.jsHandler    // JS Handler 버전 (flutter_inappwebview 권장)
DaumPostcodeAssets.jsChannel    // JS Channel 버전
```

### DataModel 필드

[DAUM 우편번호 API](https://postcode.map.daum.net/guide)의 모든 필드:
- `address`, `addressEnglish` - 전체 주소
- `zonecode` - 5자리 우편번호
- `roadAddress`, `roadAddressEnglish` - 도로명 주소
- `jibunAddress`, `jibunAddressEnglish` - 지번 주소
- [전체 목록 보기](./lib/src/data_model.dart)

## 예제

[예제 앱](./example)에서는 다음을 보여줍니다:
- ✅ 이중 WebView 지원 (webview_flutter + flutter_inappwebview)
- ✅ 다국어 UI (영문, 한글)
- ✅ 완전한 오류 처리
- ✅ Material 3 디자인

예제 실행:
```bash
cd example
flutter pub get
flutter run
```

자세한 내용은 [example/README.md](./example/README.md)를 참고하세요.

## 라이센스

이 프로젝트는 MIT 라이센스 하에 제공됩니다. 자세한 내용은 LICENSE 파일을 참조하세요.