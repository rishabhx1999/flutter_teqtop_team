import 'search_data.dart';

class ColumnData {
  String? data;
  String? name;
  String? searchable;
  String? orderable;
  SearchData? search;

  ColumnData({
    this.data,
    this.name,
    this.searchable,
    this.orderable,
    this.search,
  });

  factory ColumnData.fromJson(Map<String, dynamic> json) =>
      ColumnData(
        data: json["data"],
        name: json["name"],
        searchable: json["searchable"],
        orderable: json["orderable"],
        search: json["search"] == null
            ? null
            : SearchData.fromJson(json["search"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data,
        "name": name,
        "searchable": searchable,
        "orderable": orderable,
        "search": search == null ? null : search!.toJson(),
      };
}
