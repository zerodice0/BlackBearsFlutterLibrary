import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'postcode_search_webview_flutter.dart';
import 'postcode_search_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daum Postcode Search Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the device locale is supported
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale; // Use the supported locale
            }
          }
        }
        // Fallback to English (first locale) for unsupported languages
        return supportedLocales.first; // Locale('en')
      },
      home: const DaumPostcodeSearchExample(
        title: 'Daum Postcode Search Example',
      ),
    );
  }
}

enum WebViewType { webviewFlutter, inappWebview }

class DaumPostcodeSearchExample extends StatefulWidget {
  const DaumPostcodeSearchExample({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  State<DaumPostcodeSearchExample> createState() =>
      _DaumPostcodeSearchExampleState();
}

class _DaumPostcodeSearchExampleState extends State<DaumPostcodeSearchExample> {
  DataModel? _daumPostcodeSearchDataModel;
  WebViewType? _lastUsedWebViewType;

  Future<void> _searchAddress(WebViewType webViewType) async {
    try {
      final DataModel? model = await Navigator.of(context).push<DataModel>(
        MaterialPageRoute(
          builder: (context) => webViewType == WebViewType.webviewFlutter
              ? const PostcodeSearchWebViewFlutter()
              : const PostcodeSearchInAppWebView(),
        ),
      );

      if (model != null) {
        setState(() {
          _daumPostcodeSearchDataModel = model;
          _lastUsedWebViewType = webViewType;
        });
      }
    } catch (error) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorOccurred}: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    TableRow _buildTableRow(String label, String value) {
      return TableRow(
        children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
        ],
      );
    }

    String _getWebViewBadgeText() {
      if (_lastUsedWebViewType == null) return '';
      return _lastUsedWebViewType == WebViewType.webviewFlutter
          ? 'webview_flutter'
          : 'flutter_inappwebview';
    }

    Color _getWebViewBadgeColor() {
      if (_lastUsedWebViewType == null) return Colors.grey;
      return _lastUsedWebViewType == WebViewType.webviewFlutter
          ? Colors.blue
          : Colors.purple;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.webviewSelection,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _searchAddress(WebViewType.webviewFlutter),
                        icon: const Icon(Icons.web),
                        label: Text(l10n.webviewFlutterButtonLabel),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.webviewFlutterDescription,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _searchAddress(WebViewType.inappWebview),
                        icon: const Icon(Icons.web_asset),
                        label: Text(l10n.inappWebviewButtonLabel),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.inappWebviewDescription,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: _daumPostcodeSearchDataModel != null,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              l10n.searchResults,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_lastUsedWebViewType != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getWebViewBadgeColor(),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getWebViewBadgeText(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        Table(
                          border: TableBorder.all(color: Colors.grey.shade300),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                          },
                          children: [
                            _buildTableRow(
                              l10n.koreanAddress,
                              _daumPostcodeSearchDataModel?.address ?? '',
                            ),
                            _buildTableRow(
                              l10n.englishAddress,
                              _daumPostcodeSearchDataModel?.addressEnglish ??
                                  '',
                            ),
                            _buildTableRow(
                              l10n.zipcode,
                              _daumPostcodeSearchDataModel?.zonecode ?? '',
                            ),
                            _buildTableRow(
                              l10n.jibunAddress,
                              _daumPostcodeSearchDataModel
                                      ?.autoJibunAddress ??
                                  '',
                            ),
                            _buildTableRow(
                              l10n.jibunAddressEnglish,
                              _daumPostcodeSearchDataModel
                                      ?.autoJibunAddressEnglish ??
                                  '',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
