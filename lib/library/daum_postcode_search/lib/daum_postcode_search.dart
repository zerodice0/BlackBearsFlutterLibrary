library daum_postcode_search;

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

class DaumPostcodeSearch extends StatefulWidget {
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
          "http://localhost:8080/daum_postcode_search/assets/html/address_search.html",
        ),
      ),
    );
  }
}
