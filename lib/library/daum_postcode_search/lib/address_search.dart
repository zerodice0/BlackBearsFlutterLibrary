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

  const DaumPostcodeSearch({
    Key? key,
    this.webPageTitle = "주소 검색",
  }) : super(key: key);

  @override
  _DaumPostcodeSearchState createState() => _DaumPostcodeSearchState();
}

class _DaumPostcodeSearchState extends State<DaumPostcodeSearch> {
  InAppLocalhostServer localhostServer = InAppLocalhostServer();

  late InAppWebViewController _controller;
  InAppWebViewController get controller => _controller;
  int progress = 0;

  @override
  void initState() {
    localhostServer.start();
    super.initState();
  }

  @override
  void dispose() {
    localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: Uri.parse(
          "http://localhost:8080/packages/daum_postcode_search/lib/assets/daum_search.html",
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
  }
}
