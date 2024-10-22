library daum_postcode_search;

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

import 'data_model.dart';

class DaumPostcodeSearch extends StatefulWidget {
  final String webPageTitle;
  final String assetPath;
  final _DaumPostcodeSearchState _state = _DaumPostcodeSearchState();

  final void Function(InAppWebViewController controller,
      WebResourceRequest request, WebResourceError error)? onReceivedError;
  final void Function(InAppWebViewController controller, int progress)?
      onProgressChanged;
  final void Function(
          InAppWebViewController controller, ConsoleMessage consoleMessage)?
      onConsoleMessage;
  final InAppWebViewSettings? initialSettings;

  InAppWebViewController? get controller => this._state._controller;

  DaumPostcodeSearch({
    Key? key,
    this.webPageTitle = "주소 검색",
    this.assetPath =
        "packages/daum_postcode_search/lib/assets/daum_search.html",
    this.onReceivedError,
    this.onProgressChanged,
    this.onConsoleMessage,
    this.initialSettings,
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
          url: WebUri(
            "http://localhost:8080/${widget.assetPath}",
          ),
        ),
        initialSettings: widget.initialSettings ??
            InAppWebViewSettings(
              mediaPlaybackRequiresUserGesture: false,
              useHybridComposition: true,
              allowsInlineMediaPlayback: true,
            ),
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
        onReceivedError: widget.onReceivedError,
      );
    } else {
      result = Center(
        child: CircularProgressIndicator(),
      );
    }

    return result;
  }
}
