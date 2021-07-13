import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:flutter/material.dart';

class SearchingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("주소 검색 페이지입니다."),
        centerTitle: true,
      ),
      body: DaumPostcodeSearch(),
    );
  }
}
