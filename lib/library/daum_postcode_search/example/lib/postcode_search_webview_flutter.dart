import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'l10n/app_localizations.dart';

class PostcodeSearchWebViewFlutter extends StatefulWidget {
  const PostcodeSearchWebViewFlutter({Key? key}) : super(key: key);

  @override
  State<PostcodeSearchWebViewFlutter> createState() =>
      _PostcodeSearchWebViewFlutterState();
}

class _PostcodeSearchWebViewFlutterState
    extends State<PostcodeSearchWebViewFlutter> {
  final _server = DaumPostcodeLocalServer();
  late WebViewController _controller;
  bool _isReady = false;
  bool _isError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initServer();
  }

  Future<void> _initServer() async {
    try {
      await _server.start();

      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel(
          'DaumPostcodeChannel',
          onMessageReceived: (JavaScriptMessage message) {
            try {
              final result =
                  DaumPostcodeCallbackParser.fromPostMessage(message.message);
              if (result != null) {
                Navigator.of(context).pop(result);
              }
            } catch (e) {
              final l10n = AppLocalizations.of(context)!;
              setState(() {
                _isError = true;
                _errorMessage = l10n.parsingError('$e');
              });
            }
          },
        )
        ..setNavigationDelegate(NavigationDelegate(
          onWebResourceError: (error) {
            setState(() {
              _isError = true;
              _errorMessage = error.description;
            });
          },
        ))
        ..loadRequest(
            Uri.parse('${_server.url}/${DaumPostcodeAssets.jsChannel}'));

      setState(() => _isReady = true);
    } catch (e) {
      setState(() {
        _isError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _server.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isError) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.searchPageTitleWebViewFlutter)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage ?? l10n.errorOccurred),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isError = false;
                    _isReady = false;
                  });
                  _initServer();
                },
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isReady) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.searchPageTitleWebViewFlutter)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchPageTitleWebViewFlutter),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
