import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'l10n/app_localizations.dart';

class PostcodeSearchInAppWebView extends StatefulWidget {
  const PostcodeSearchInAppWebView({Key? key}) : super(key: key);

  @override
  State<PostcodeSearchInAppWebView> createState() =>
      _PostcodeSearchInAppWebViewState();
}

class _PostcodeSearchInAppWebViewState
    extends State<PostcodeSearchInAppWebView> {
  final _server = DaumPostcodeLocalServer();
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
        appBar: AppBar(title: Text(l10n.searchPageTitleInAppWebView)),
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
        appBar: AppBar(title: Text(l10n.searchPageTitleInAppWebView)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchPageTitleInAppWebView),
        centerTitle: true,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri('${_server.url}/${DaumPostcodeAssets.jsHandler}'),
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          useShouldOverrideUrlLoading: false,
        ),
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
            handlerName: 'onComplete',
            callback: (args) {
              try {
                if (args.isNotEmpty) {
                  final data = args[0] as Map<String, dynamic>;
                  final result = DaumPostcodeCallbackParser.fromMap(data);
                  if (result != null) {
                    Navigator.of(context).pop(result);
                  }
                }
              } catch (e) {
                final l10n = AppLocalizations.of(context)!;
                setState(() {
                  _isError = true;
                  _errorMessage = l10n.parsingError('$e');
                });
              }
            },
          );
        },
        onReceivedError: (controller, request, error) {
          setState(() {
            _isError = true;
            _errorMessage = error.description;
          });
        },
      ),
    );
  }
}
