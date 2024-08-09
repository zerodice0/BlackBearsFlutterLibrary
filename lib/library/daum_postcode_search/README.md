[README-EN](https://github.com/zerodice0/BlackBearsFlutterLibrary/blob/main/lib/library/daum_postcode_search/README.md)

[README-KR](https://github.com/zerodice0/BlackBearsFlutterLibrary/blob/main/lib/library/daum_postcode_search/README.KR.md)

# DAUM Postcode Search Package
This package is for using the [DAUM postcode service] (https://postcode.map.daum.net/guide) in Flutter. Using InAppWebView, the internal server is operated using the HTML file included in the package, and through this, the [DAUM postcode service](https://postcode.map.daum.net/guide) is used to search for a domestic address.

## Setup
#### Android
Add `android:usesCleartextTraffic="true"` to your `<application>` in AndroidManifest.xml. Clear text traffic-related errors occur if you do not set permissions because some items in [DAUM postcode service](https://postcode.map.daum.net/guide) do not use SSL.

## Example
Below is an example of implementing a search page using the Daum Postcode Search package.
```
class SearchingPage extends StatefulWidget {
  @override
  _SearchingPageState createState() => _SearchingPageState();
}

class _SearchingPageState extends State<`SearchingPage> {
  bool _isError = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    DaumPostcodeSearch daumPostcodeSearch = DaumPostcodeSearch(
      onConsoleMessage: (_, message) => print(message),
      onLoadError: (controller, uri, errorCode, message) => setState(
        () {
          _isError = true;
          errorMessage = message;
        },
      ),
      onLoadHttpError: (controller, uri, errorCode, message) => setState(
        () {
          _isError = true;
          errorMessage = message;
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
You can access the Controller of InAppWebView by using the DaumPostcodeSearch object daumPostcodeSearch created as a variable in build, and by using this, when an error occurs, it is possible to process such as Refresh.

In the example, when an error occurs, the status value _isError is set to true, and the refresh and error messages are output using Visibility.

-----

The example below is an example that displays the search results received using the SearchingPage written above on the screen.
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
This is a DaumPostcodeSearchExample that uses the DataModel object _daumPostcodeSearchDataModel to display the result screen. For items provided by DataModel, refer to [DataModel](https://github.com/zerodice0/BlackBearsFlutterLibrary/blob/main/lib/library/daum_postcode_search/lib/data_model.dart).
