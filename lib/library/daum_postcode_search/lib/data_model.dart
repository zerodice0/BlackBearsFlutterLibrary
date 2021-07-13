class DataModel {
  final String postcode;
  final String postcode1;
  final String postcode2;
  final String postcodeSeq;
  final String zonecode;
  final String address;
  final String addressEnglish;
  final String addressType;
  final String bcode;
  final String bname;
  final String bnameEnglish;
  final String bname2English;
  final String sido;
  final String sidoEnglish;
  final String sigungu;
  final String sigunguEnglish;
  final String sigunguCode;
  final String userLanguageType;
  final String query;
  final String buildingName;
  final String buildingCode;
  final String apartment;
  final String jibunAddress;
  final String jibunAddressEnglish;
  final String roadAddress;
  final String roadAddressEnglish;
  final String autoJibunAddress;
  final String autoJibunAddressEnglish;
  final String userSelectedType;
  final String noSelected;
  final String hname;
  final String roadnameCode;
  final String roadname;
  final String roadnameEnglish;

  DataModel({
    required this.postcode,
    required this.postcode1,
    required this.postcode2,
    required this.postcodeSeq,
    required this.zonecode,
    required this.address,
    required this.addressEnglish,
    required this.addressType,
    required this.bcode,
    required this.bname,
    required this.bnameEnglish,
    required this.bname2English,
    required this.sido,
    required this.sidoEnglish,
    required this.sigungu,
    required this.sigunguEnglish,
    required this.sigunguCode,
    required this.userLanguageType,
    required this.query,
    required this.buildingName,
    required this.buildingCode,
    required this.apartment,
    required this.jibunAddress,
    required this.jibunAddressEnglish,
    required this.roadAddress,
    required this.roadAddressEnglish,
    required this.autoJibunAddress,
    required this.autoJibunAddressEnglish,
    required this.userSelectedType,
    required this.noSelected,
    required this.hname,
    required this.roadnameCode,
    required this.roadname,
    required this.roadnameEnglish,
  });

  static fromMap(Map<String, dynamic> map) {
    return DataModel(
      postcode: map["postcode"] ?? "",
      postcode1: map["postcode1"] ?? "",
      postcode2: map["postcode2"] ?? "",
      postcodeSeq: map["postcodeSeq"] ?? "",
      zonecode: map["zonecode"] ?? "",
      address: map["address"] ?? "",
      addressEnglish: map["addressEnglish"] ?? "",
      addressType: map["addressType"] ?? "",
      bcode: map["bcode"] ?? "",
      bname: map["bname"] ?? "",
      bnameEnglish: map["bnameEnglish"] ?? "",
      bname2English: map["bname2English"] ?? "",
      sido: map["sido"] ?? "",
      sidoEnglish: map["sidoEnglish"] ?? "",
      sigungu: map["sigungu"] ?? "",
      sigunguEnglish: map["sigunguEnglish"] ?? "",
      sigunguCode: map["sigunguCode"] ?? "",
      userLanguageType: map["userLanguageType"] ?? "",
      query: map["query"] ?? "",
      buildingName: map["buildingName"] ?? "",
      buildingCode: map["buildingCode"] ?? "",
      apartment: map["apartment"] ?? "",
      jibunAddress: map["jibunAddress"] ?? "",
      jibunAddressEnglish: map["jibunAddressEnglish"] ?? "",
      roadAddress: map["roadAddress"] ?? "",
      roadAddressEnglish: map["roadAddressEnglish"] ?? "",
      autoJibunAddress: map["autoJibunAddress"] ?? "",
      autoJibunAddressEnglish: map["autoJibunAddressEnglish"] ?? "",
      userSelectedType: map["userSelectedType"] ?? "",
      noSelected: map["noSelected"] ?? "",
      hname: map["hname"] ?? "",
      roadnameCode: map["roadnameCode"] ?? "",
      roadname: map["roadname"] ?? "",
      roadnameEnglish: map["roadnameEnglish"] ?? "",
    );
  }
}
