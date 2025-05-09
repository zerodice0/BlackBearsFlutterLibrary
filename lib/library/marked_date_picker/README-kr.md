# Marked Date Picker

특정 날짜에 표시를 할 수 있는 커스터마이즈된 Flutter DatePicker 라이브러리입니다.

[![pub package](https://img.shields.io/pub/v/marked_date_picker.svg)](https://pub.dev/packages/marked_date_picker)

## 소개

이 라이브러리는 Flutter의 기본 `showDatePicker`를 기반으로 하지만, 날짜에 표시(마크)를 할 수 있는 기능을 추가했습니다. 일정, 이벤트, 중요한 날짜 등을 캘린더에 표시해야 할 때 유용합니다.

## 기능

- 특정 날짜에 표시(마크) 기능
- 월이 변경될 때 표시된 날짜 목록 업데이트 가능
- 커스텀 색상 지원 (오늘 날짜, 표시된 날짜, 선택된 날짜 등)
- 표시에 대한 커스텀 위젯 지원

## 설치

`pubspec.yaml` 파일에 패키지를 추가하세요:

```yaml
dependencies:
  marked_date_picker: ^0.0.4
```

그리고 패키지를 설치하세요:

```
flutter pub get
```

## 사용 방법

1. 패키지를 임포트합니다:

```dart
import 'package:marked_date_picker/marked_date_picker.dart';
```

2. `showMarkedDatePicker`를 호출합니다:

```dart
// 표시할 날짜 목록을 관리하는 ValueNotifier
ValueNotifier<List<DateTime>> markedDatesNotifier = ValueNotifier<List<DateTime>>(
  _getMarkedList(date.year, date.month),
);

// 데이트 피커 표시
final DateTime? selectedDate = await showMarkedDatePicker(
  context: context,
  initialDate: date,
  firstDate: DateTime(2019),
  lastDate: DateTime.now(),
  // 표시할 날짜 목록
  markedDates: [
    DateTime.parse("2021-09-02"),
    DateTime.parse("2021-09-04"),
    DateTime.parse("2021-09-09"),
    DateTime.parse("2021-09-10"),
  ],
  // 월이 변경될 때 표시된 날짜 목록을 업데이트하기 위한 리스너
  markedDatesListenable: markedDatesNotifier,
  // 월이 변경될 때 호출되는 콜백
  updateMonthCallback: (year, month) {
    // 월별로 다른 표시 날짜 목록을 로드
    markedDatesNotifier.value = _getMarkedList(year, month);
  },
  // 선택적 커스터마이징
  todayColor: Colors.blue,
  markedColor: Colors.red,
  selectedDayColor: Colors.white,
  selectedDayBackground: Colors.green,
);

// 표시할 날짜 목록을 가져오는 예시 함수
List<DateTime> _getMarkedList(int year, int month) {
  // 여기서 API 호출이나 로컬 데이터에서 표시할 날짜 목록을 가져옵니다
  return [
    DateTime(year, month, 2),
    DateTime(year, month, 15),
    DateTime(year, month, 20),
  ];
}
```

## 추가 옵션

`showMarkedDatePicker`는 기본 Flutter `showDatePicker`의 모든 옵션을 지원하며, 다음과 같은 추가 옵션도 제공합니다:

- `markedDates`: 표시할 날짜 목록
- `markedDatesListenable`: 달력 변경 시 표시된 날짜를 동적으로 업데이트하기 위한 ValueListenable
- `updateMonthCallback`: 월이 변경될 때 호출되는 콜백
- `marking`: 표시에 사용할 커스텀 위젯
- `todayColor`: 오늘 날짜의 색상
- `markedColor`: 표시된 날짜의 색상
- `selectedDayColor`: 선택된 날짜의 텍스트 색상
- `selectedDayBackground`: 선택된 날짜의 배경 색상
- `anchorPoint`: 다이얼로그 앵커 포인트

## 이슈 및 기여 방법

### 이슈 보고하기

문제가 발생하거나 기능 요청이 있으면 [GitHub 저장소](https://github.com/zerodice0/BlackBearsFlutterLibrary/tree/main/lib/library/marked_date_picker)에 이슈를 제출해주세요. 이슈 보고 시 다음 정보를 포함해주세요:

- 명확하고 설명적인 제목
- 문제를 재현하는 단계
- 예상된 동작과 실제로 발생한 동작
- Flutter/Dart 버전 및 기기 정보
- 가능한 경우 스크린샷이나 코드 샘플

### 기여 가이드라인

기여는 언제나 환영합니다! 다음은 기여하는 방법입니다:

1. **저장소를 포크(fork)**하고 `main` 브랜치에서 여러분의 브랜치를 생성하세요
2. **수정 사항을 적용**하고 프로젝트 코드 스타일을 따르는지 확인하세요
3. 변경 사항에 대한 명확한 설명과 함께 **풀 리퀘스트(PR)를 제출**하세요

#### 개발 가이드라인

- Flutter의 [스타일 가이드](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)를 따르세요
- 프로젝트의 커밋 컨벤션을 따르는 의미 있는 커밋 메시지를 작성하세요
- 변경 사항을 집중적으로 유지하고 관련 없는 변경 사항은 다른 PR로 분리하세요
- 변경된 기능에 대한 문서를 업데이트하세요

#### 환경 설정

```dart
flutter --version  // Flutter 3.0.0 이상인지 확인
flutter pub get    // 의존성 설치
```

## 라이센스

이 프로젝트는 MIT 라이센스를 따릅니다.

---

영어 버전은 [README.md](README.md)를 참조하세요. 