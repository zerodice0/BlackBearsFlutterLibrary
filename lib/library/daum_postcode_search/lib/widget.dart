library daum_postcode_search;

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

import 'data_model.dart';

class DaumPostcodeSearch extends StatefulWidget {
  final String webPageTitle;
  final String assetPath;
  final _DaumPostcodeSearchState _state = _DaumPostcodeSearchState();

  final void Function(InAppWebViewController controller, Uri? url,
      int statusCode, String description)? onLoadHttpError;
  final void Function(InAppWebViewController controller, Uri? url, int code,
      String message)? onLoadError;
  final void Function(InAppWebViewController controller, int progress)?
      onProgressChanged;
  final void Function(
          InAppWebViewController controller, ConsoleMessage consoleMessage)?
      onConsoleMessage;
  final InAppWebViewGroupOptions? initialOption;
  final Future<PermissionRequestResponse?> Function(
      InAppWebViewController controller,
      String origin,
      List<String> resources)? androidOnPermissionRequest;

  InAppWebViewController? get controller => this._state._controller;

  DaumPostcodeSearch({
    Key? key,
    this.webPageTitle = "주소 검색",
    this.assetPath =
        "packages/daum_postcode_search/lib/assets/daum_search.html",
    this.onLoadError,
    this.onLoadHttpError,
    this.onProgressChanged,
    this.androidOnPermissionRequest,
    this.onConsoleMessage,
    this.initialOption,
  }) : super(key: key);

  @override
  _DaumPostcodeSearchState createState() => _state;
}

class _DaumPostcodeSearchState extends State<DaumPostcodeSearch> {
  InAppLocalhostServer localhostServer = InAppLocalhostServer();

  InAppWebViewController? _controller;
  InAppWebViewController? get controller => _controller;
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
        initialOptions: widget.initialOption ??
            InAppWebViewGroupOptions(
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
        androidOnPermissionRequest: widget.androidOnPermissionRequest ??
            (InAppWebViewController controller, String origin,
                List<String> resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
        onWebViewCreated: (InAppWebViewController webViewController) async {
          webViewController.addJavaScriptHandler(
              handlerName: 'onSelectAddress',
              callback: (args) {
                Navigator.of(context).pop(
                  DataModel.fromMap(
                    args[0],
                  ),
                );
              });

          this._controller = webViewController;
        },
        onConsoleMessage: widget.onConsoleMessage,
        onProgressChanged: widget.onProgressChanged,
        onLoadHttpError: widget.onLoadHttpError,
        onLoadError: widget.onLoadError,
      );
    } else {
      result = Center(
        child: CircularProgressIndicator(),
      );
    }

    return result;
  }
}
