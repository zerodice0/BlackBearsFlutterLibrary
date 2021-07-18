library daum_postcode_search;

import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

import 'data_model.dart';

class DaumPostcodeSearch extends StatefulWidget {
  static Future<void> initialize({bool isDebugable = false}) async {
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(
        isDebugable,
      );

      var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController =
            AndroidServiceWorkerController.instance();

        serviceWorkerController.serviceWorkerClient =
            AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            return null;
          },
        );
      }
    }
  }

  final String webPageTitle;
  final String assetPath;
  final _DaumPostcodeSearchState state = _DaumPostcodeSearchState();

  DaumPostcodeSearch({
    Key? key,
    this.webPageTitle = "주소 검색",
    this.assetPath =
        "packages/daum_postcode_search/lib/assets/daum_search.html",
  }) : super(key: key);

  @override
  _DaumPostcodeSearchState createState() => state;
}

class _DaumPostcodeSearchState extends State<DaumPostcodeSearch> {
  InAppLocalhostServer localhostServer = InAppLocalhostServer();

  late InAppWebViewController _controller;
  InAppWebViewController get controller => _controller;
  int progress = 0;
  bool isServerRunning = false;

  @override
  void initState() {
    super.initState();
    localhostServer.start().then((_) {
      setState(
        () => isServerRunning = true,
      );
    });
  }

  @override
  void dispose() {
    localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (isServerRunning) {
      result = InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(
            "http://localhost:8080/${widget.assetPath}",
          ),
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
          ),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
          ),
        ),
        onConsoleMessage: (controller, consoleMessage) {
          print(consoleMessage);
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {
          setState(() {
            this.progress = progress ~/ 100;
          });
        },
        androidOnPermissionRequest: (InAppWebViewController controller,
            String origin, List<String> resources) async {
          return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT);
        },
        onWebViewCreated: (InAppWebViewController webViewController) async {
          webViewController.addJavaScriptHandler(
              handlerName: 'onSelectAddress',
              callback: (args) {
                try {
                  Navigator.of(context).pop(
                    DataModel.fromMap(
                      args[0],
                    ),
                  );
                } catch (error) {
                  print(error);
                }
              });

          this._controller = webViewController;
        },
        onLoadHttpError: (
          InAppWebViewController controller,
          Uri? url,
          int code,
          String message,
        ) {
          print(message);
        },
        onLoadError: (
          InAppWebViewController controller,
          Uri? url,
          int code,
          String message,
        ) {
          print(message);
        },
      );
    } else {
      result = Center(
        child: CircularProgressIndicator(),
      );
    }

    return result;
  }
}
