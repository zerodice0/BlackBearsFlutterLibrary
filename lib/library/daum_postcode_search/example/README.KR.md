[README-EN](https://github.com/zerodice0/BlackBearsFlutterLibrary/blob/main/lib/library/daum_postcode_search/README.md)

[README-KR](https://github.com/zerodice0/BlackBearsFlutterLibrary/blob/main/lib/library/daum_postcode_search/README.KR.md)

# DAUM 우편번호 검색 패키지
이 패키지는 Flutter에서 [DAUM 우편번호 서비스](https://postcode.map.daum.net/guide)를 사용하기 위한 패키지입니다. InAppWebView를 사용해서 패키지 내에 포함된 HTML파일을 사용하여 내부 서버를 동작시키고, 이를 통해 [DAUM 우편번호 서비스](https://postcode.map.daum.net/guide)를 사용하여 국내 주소를 검색합니다.

## 설정
#### Android
AndroidManifest.xml의 application에 `android:usesCleartextTraffic="true"`을 추가해주세요. [DAUM 우편번호 서비스](https://postcode.map.daum.net/guide) 내의 일부 항목이 SSL을 사용하지 않아서인지, 권한을 설정해주지 않으면 Clear text traffic 관련 에러가 발생합니다.
#### iOS
Network 사용권한이 필요하므로 Info.plist에 아래의 내용을 추가해주세요. 추가하지 않을 경우에는 하얀 화면만 뜨게 됩니다.
```
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key><true/>
</dict>
```

## 마이그레이션 (0.0.1 -> 0.0.2)
InAppWebView의 버전이 6.X로 업데이트되면서, onLoadError와 onLoadHttpError가 deprecated되었습니다. 대신 onReceivedError를 사용해주세요.

## 예제
아래는 Daum Postcode Search 패키지를 사용해서 검색 페이지를 구현한 예제엡니다.
```
class SearchingPage extends StatefulWidget {
  @override
  _SearchingPageState createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  bool _isError = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    DaumPostcodeSearch daumPostcodeSearch = DaumPostcodeSearch(
      onConsoleMessage: (_, message) => print(message),
      onReceivedError: (controller, request, error) => setState(
        () {
          _isError = true;
          errorMessage = error.description;
        },
      ),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text("주소 검색 페이지입니다."),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: daumPostcodeSearch,
            ),
            Visibility(
              visible: _isError,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(errorMessage ?? ""),
                  ElevatedButton(
                    child: Text("Refresh"),
                    onPressed: () {
                      daumPostcodeSearch.controller?.reload();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
build에서 변수로 작성한 DaumPostcodeSearch의 객체 daumPostcodeSearch을 사용해서 InAppWebView의 Controller에 접근할 수 있으며, 이를 사용하여 에러가 발생했을 시 Refresh 등의 처리가 가능합니다.

예제에서는 에러가 발생했을 경우 상태값 _isError를 true로 설정하며, Visibility를 사용하여 새로고침과 에러 메시지를 출력하도록 작성했습니다.

-----

아래의 예제는 위에서 작성한 SearchingPage를 사용해서 받아온 검색 결과를 화면상에 출력해주는 예제입니다.
```
class DaumPostcodeSearchExample extends StatefulWidget {
  DaumPostcodeSearchExample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _DaumPostcodeSearchExampleState createState() =>
      _DaumPostcodeSearchExampleState();
}

class _DaumPostcodeSearchExampleState extends State<DaumPostcodeSearchExample> {
  DataModel? _daumPostcodeSearchDataModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TableRow _buildTableRow(String label, String value) {
      return TableRow(
        children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Text(label, textAlign: TextAlign.center),
          ),
          TableCell(
            child: Text(value, textAlign: TextAlign.center),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    DataModel model = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchingPage(),
                      ),
                    );

                    setState(
                      () {
                        _daumPostcodeSearchDataModel = model;
                      },
                    );
                  } catch (error) {
                    print(error);
                  }
                },
                icon: Icon(Icons.search),
                label: Text("주소 검색"),
              ),
              Visibility(
                visible: _daumPostcodeSearchDataModel != null,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: RichText(
                            text: TextSpan(
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                TextSpan(text: "주소 검색 결과"),
                              ],
                            ),
                          ),
                        ),
                        Table(
                          border: TableBorder.symmetric(
                              inside: BorderSide(color: Colors.grey)),
                          columnWidths: {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                          },
                          children: [
                            _buildTableRow(
                              "한글주소",
                              _daumPostcodeSearchDataModel?.address ?? "",
                            ),
                            _buildTableRow(
                              "영문주소",
                              _daumPostcodeSearchDataModel?.addressEnglish ??
                                  "",
                            ),
                            _buildTableRow(
                              "우편번호",
                              _daumPostcodeSearchDataModel?.zonecode ?? "",
                            ),
                            _buildTableRow(
                              "지번주소",
                              _daumPostcodeSearchDataModel?.autoJibunAddress ??
                                  "",
                            ),
                            _buildTableRow(
                              "지번주소(영문)",
                              _daumPostcodeSearchDataModel
                                      ?.autoJibunAddressEnglish ??
                                  "",
                            )
                          ],
                        )
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
```
DataModel의 객체 _daumPostcodeSearchDataModel를 사용해서 결과 화면을 표시하는 DaumPostcodeSearchExample입니다. DataModel에서 제공하는 항목은 [DataModel](https://github.com/zerodice0/BlackBearsFlutterLibrary/blob/main/lib/library/daum_postcode_search/lib/data_model.dart)을 참고해주세요.