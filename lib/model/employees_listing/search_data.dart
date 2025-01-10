class SearchData {
  String? value;
  dynamic regex;

  SearchData({
    this.value,
    this.regex,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
    value: json["value"],
    regex: json["regex"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "regex": regex,
  };
}