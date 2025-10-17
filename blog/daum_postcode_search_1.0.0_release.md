# daum_postcode_search 1.0.0 출시 - Zero-Dependency 아키텍처로의 전환

**작성일**: 2024년 10월
**패키지**: daum_postcode_search
**버전**: 1.0.0
**카테고리**: Flutter 패키지 개발

---

## 서론

daum_postcode_search는 Daum 우편번호 서비스를 Flutter 애플리케이션에 쉽게 통합할 수 있는 패키지입니다. 그동안 패키지는 특정 WebView 라이브러리에 의존하는 형태로 개발되어 왔습니다. 이번 1.0.0 버전에서는 완전히 새로운 아키텍처로 재설계되었으며, 더 이상 특정 WebView 패키지에 의존하지 않는 zero-dependency 패키지로 탈바꿈했습니다.

이 글에서는 1.0.0 버전에서 무엇이 변경되었는지, 왜 이런 변경을 결정했는지, 그리고 기존 사용자들이 어떻게 마이그레이션할 수 있는지 자세히 살펴보겠습니다.

---

## 주요 변경사항

### 1. Zero-Dependency 아키텍처

가장 중요한 변경사항은 패키지에서 모든 WebView 의존성을 제거했다는 점입니다.

**이전 (0.0.4)**:
- `flutter_inappwebview` 의존성 필수
- 특정 WebView 구현에 강하게 결합됨
- 패키지 크기: 3~4MB (의존성 포함)
- 사용자는 InAppWebView만 선택 가능

**현재 (1.0.0)**:
- Zero dependencies
- 로컬 HTTP 서버와 HTML 자산만 제공
- 패키지 크기: 약 50KB
- 사용자가 WebView 선택 가능 (webview_flutter, flutter_inappwebview 또는 기타)

### 2. 획기적인 패키지 크기 감소

1.0.0 버전은 패키지 크기를 98.5% 감소시켰습니다.

- **0.0.3**: 약 3~4MB
- **1.0.0**: 약 50KB
- **감소율**: 98.5%

이는 사용자의 최종 애플리케이션 번들 크기를 크게 줄일 수 있으며, 특히 모바일 환경에서 다운로드 시간과 설치 크기를 개선합니다.

### 3. 사용자에게 선택권 부여

이제 개발자들은 자신의 프로젝트에 맞는 WebView 구현을 자유롭게 선택할 수 있습니다.

- **webview_flutter**: 공식 Flutter WebView 플러그인, 더 간단한 API
- **flutter_inappwebview**: 더 많은 고급 기능과 커스터마이제이션 옵션
- **기타 WebView 패키지**: 다른 솔루션도 자유롭게 사용 가능

이러한 유연성은 프로젝트의 요구사항에 따라 최적의 솔루션을 선택할 수 있게 해줍니다.

---

## 새로운 기능 및 API

### 1. DaumPostcodeLocalServer

로컬 HTTP 서버를 관리하는 클래스입니다. 이 서버는 HTML 자산을 제공하고 WebView에서 접근 가능한 엔드포인트를 만듭니다.

```dart
import 'package:daum_postcode_search/daum_postcode_search.dart';

// 서버 생성
final server = DaumPostcodeLocalServer(
  address: 'localhost',  // 기본값
  port: 8080,            // 기본값
);

// 서버 시작
await server.start();

// 서버 URL 사용
print(server.url);  // http://localhost:8080

// 서버 상태 확인
print(server.isRunning);  // true

// 서버 종료
await server.stop();
```

### 2. DaumPostcodeCallbackParser

WebView에서 받은 콜백 데이터를 파싱하여 주소 정보 모델로 변환합니다. 다양한 콜백 방식을 지원합니다.

```dart
// PostMessage 방식
final result = DaumPostcodeCallbackParser.fromPostMessage(jsonData);

// JavaScript Handler 방식
final result = DaumPostcodeCallbackParser.fromJsHandler(data);

// URL Scheme 방식
final result = DaumPostcodeCallbackParser.fromUrlScheme(url);

// 결과 사용
if (result != null) {
  print('주소: ${result.address}');
  print('우편번호: ${result.zonecode}');
}
```

### 3. DaumPostcodeAssets

HTML 파일 경로를 상수로 제공하여 필요한 HTML 버전을 쉽게 선택할 수 있습니다.

```dart
// 4가지 콜백 메커니즘 제공
DaumPostcodeAssets.urlScheme      // URL Scheme 콜백
DaumPostcodeAssets.postMessage    // PostMessage (webview_flutter 권장)
DaumPostcodeAssets.jsHandler      // JS Handler (flutter_inappwebview 권장)
DaumPostcodeAssets.jsChannel      // JS Channel
```

### 4. 다양한 콜백 메커니즘

WebView 구현의 특성에 맞게 4가지 다른 콜백 방식을 제공합니다.

- **URL Scheme**: 고전적인 방식, 어느 WebView에서나 작동
- **PostMessage**: 웹 표준 방식, webview_flutter에 최적화
- **JavaScript Handler**: InAppWebView의 고급 기능 활용
- **JavaScript Channel**: Dart와 JavaScript 간의 양방향 통신

---

## Breaking Changes 및 마이그레이션

### Breaking Changes

0.0.4 버전에서 1.0.0으로 업그레이드할 때 주의해야 할 주요 변경사항은 다음과 같습니다.

**제거된 기능**:
1. `DaumPostcodeSearch` 위젯 - 더 이상 사용 불가
2. 모든 WebView 관련 콜백 (`onConsoleMessage`, `onReceivedError` 등)
3. `flutter_inappwebview` 의존성

**새로운 방식**:
- 사용자가 직접 WebView 통합을 구현해야 함
- 로컬 서버와 콜백 파서를 이용하여 수동으로 통합

### 마이그레이션 방법

#### Step 1: pubspec.yaml 업데이트

**이전 (0.0.4)**:
```yaml
dependencies:
  daum_postcode_search: ^0.0.4
```

**현재 (1.0.0)**:
```yaml
dependencies:
  daum_postcode_search: ^1.0.0
  webview_flutter: ^4.8.0  # 또는 flutter_inappwebview: ^6.1.5
```

#### Step 2: 코드 마이그레이션

**이전 (0.0.4)**:
```dart
import 'package:daum_postcode_search/daum_postcode_search.dart';

// 이전에는 위젯으로 제공됨
DaumPostcodeSearch(
  onConsoleMessage: (_, message) => print(message),
  onReceivedError: (controller, request, error) => setState(...),
)
```

**현재 (1.0.0) - webview_flutter 예제**:
```dart
import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PostcodeSearchPage extends StatefulWidget {
  @override
  State<PostcodeSearchPage> createState() => _PostcodeSearchPageState();
}

class _PostcodeSearchPageState extends State<PostcodeSearchPage> {
  late DaumPostcodeLocalServer _server;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializeServer();
  }

  Future<void> _initializeServer() async {
    _server = DaumPostcodeLocalServer();
    await _server.start();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_server.isRunning) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('우편번호 검색')),
      body: WebViewWidget(
        controller: WebViewController()
          ..addJavaScriptChannel(
            'DaumPostcodeChannel',
            onMessageReceived: (JavaScriptMessage message) {
              final result = DaumPostcodeCallbackParser.fromPostMessage(
                message.message,
              );
              if (result != null) {
                print('주소: ${result.address}');
                Navigator.of(context).pop(result);
              }
            },
          )
          ..loadRequest(
            Uri.parse(
              '${_server.url}/${DaumPostcodeAssets.postMessage}',
            ),
          ),
      ),
    );
  }

  @override
  void dispose() {
    _server.stop();
    super.dispose();
  }
}
```

---

## 실제 사용 예제

### webview_flutter를 사용한 예제

webview_flutter는 공식 Flutter WebView 플러그인으로, 더 간단한 API를 제공합니다.

```dart
import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<void> showPostcodeDialog(BuildContext context) async {
  final server = DaumPostcodeLocalServer();
  await server.start();

  if (!context.mounted) return;

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: WebViewWidget(
          controller: WebViewController()
            ..addJavaScriptChannel(
              'DaumPostcodeChannel',
              onMessageReceived: (message) async {
                final result = DaumPostcodeCallbackParser.fromPostMessage(
                  message.message,
                );
                if (result != null) {
                  Navigator.of(context).pop(result);
                  await server.stop();
                }
              },
            )
            ..loadRequest(
              Uri.parse(
                '${server.url}/${DaumPostcodeAssets.postMessage}',
              ),
            ),
        ),
      );
    },
  );
}
```

### flutter_inappwebview를 사용한 예제

더 많은 제어와 고급 기능이 필요한 경우 flutter_inappwebview를 사용할 수 있습니다.

```dart
import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future<void> showPostcodeDialog(BuildContext context) async {
  final server = DaumPostcodeLocalServer();
  await server.start();

  if (!context.mounted) return;

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(
              '${server.url}/${DaumPostcodeAssets.jsHandler}',
            ),
          ),
          onWebViewCreated: (controller) {
            controller.addJavaScriptHandler(
              handlerName: 'handleAddressData',
              callback: (args) async {
                final result = DaumPostcodeCallbackParser.fromJsHandler(
                  args[0],
                );
                if (result != null) {
                  Navigator.of(context).pop(result);
                  await server.stop();
                }
              },
            );
          },
        ),
      );
    },
  );
}
```

---

## 기술적 개선사항

### 1. 아키텍처 단순화

이전 버전은 특정 WebView 구현에 강하게 결합되어 있었습니다. 새로운 버전은 HTTP 서버와 데이터 파서라는 두 가지 핵심 기능만 제공하므로, 아키텍처가 훨씬 단순하고 명확합니다.

### 2. 유지보수성 향상

패키지 버전 업그레이드 시 다양한 WebView 라이브러리의 API 변경에 대응할 필요가 없습니다. 사용자가 자신의 WebView 버전을 관리하므로, 패키지는 더 안정적인 상태를 유지할 수 있습니다.

### 3. 확장성 증대

로컬 서버 기반의 아키텍처이므로, 향후 다양한 콜백 방식을 추가하거나 새로운 기능을 확장하기가 훨씬 용이합니다.

### 4. 테스트 용이성

WebView에 의존하지 않으므로 로컬 서버와 파서의 로직을 독립적으로 테스트할 수 있습니다.

---

## 설정 가이드

### Android 설정

AndroidManifest.xml의 `<application>` 태그에 다음을 추가하세요:

```xml
<application
    android:usesCleartextTraffic="true"
    ...>
</application>
```

이는 로컬 HTTP 서버 (localhost:8080)에 접속할 때 필요합니다.

### iOS 설정

Info.plist에 다음을 추가하세요:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key><true/>
</dict>
```

---

## 결론

daum_postcode_search 1.0.0은 패키지의 철학을 근본적으로 변경한 버전입니다. Zero-dependency 아키텍처로 전환함으로써 패키지 크기를 98.5% 감소시켰고, 사용자에게 WebView 선택의 자유도를 부여했으며, 유지보수성과 확장성을 크게 향상시켰습니다.

비록 기존 사용자들은 수동으로 WebView 통합을 구현해야 하는 약간의 추가 작업이 필요하지만, 장기적으로는 더욱 안정적이고 유연한 솔루션을 얻게 됩니다.

이 릴리스가 Flutter 커뮤니티에서 우편번호 검색 기능을 더 쉽고 효율적으로 사용하는 데 도움이 되길 바랍니다.

### 유용한 링크

- [pub.dev 패키지 페이지](https://pub.dev/packages/daum_postcode_search)
- [GitHub 저장소](https://github.com/zerodice0/BlackBearsFlutterLibrary/tree/main/lib/library/daum_postcode_search)
- [Daum 우편번호 서비스](https://postcode.map.daum.net/guide)
