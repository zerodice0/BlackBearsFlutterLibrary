# BlackBear's Flutter Library
각 라이브러리는 library 하위 경로에 포함되어있습니다. 
- SharedPreferencesHelper
  - SharedPreferences를 사용할 때 String 타입 키 값을 사용해야하는데, 키 값을 중복으로 입력해야하거나 기본값을 매번 할당하기 귀찮아서 만든 패키지입니다.
- DaumPostcodeSearch
  - KOPO를 사용하려고 했으나, 에러처리 및 커스터마이징에 제약을 느껴서 생성한 패키지입니다.
- MarkedDatePicker
  - 달력에 선택한 날짜를 표시하는 라이브러리입니다. 

# launch.json
Visual Studio Code에서 아래와 같이 `launch.json`을 작성하여, 각각 라이브러리 예제 코드를 실행할 수 있습니다. 
```
{
  "configurations": [
    {
      "name": "DaumPostcodeSearch example",
      "program": "lib/library/daum_postcode_search/example/lib/main.dart",
      "request": "launch",
      "type": "dart",
      "args": []
    },
    {
      "name": "MarkedDatePicker example",
      "program": "lib/library/marked_date_picker/example/lib/main.dart",
      "request": "launch",
      "type": "dart",
      "args": []
    },
    {
      "name": "blackbear_flutter_library",
      "request": "launch",
      "type": "dart"
    }
  ]
}
```