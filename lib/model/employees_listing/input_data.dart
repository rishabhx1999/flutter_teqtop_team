import 'package:teqtop_team/model/employees_listing/column_data.dart';
import 'package:teqtop_team/model/employees_listing/order_data.dart';
import 'package:teqtop_team/model/employees_listing/search_data.dart';

class InputData {
  String? token;
  String? users;
  String? draw;
  List<ColumnData?>? columns;
  List<OrderData?>? order;
  String? start;
  String? length;
  SearchData? search;
  String? empty;

  InputData({
    this.token,
    this.users,
    this.draw,
    this.columns,
    this.order,
    this.start,
    this.length,
    this.search,
    this.empty,
  });

  factory InputData.fromJson(Map<String, dynamic> json) => InputData(
        token: json["token"],
        users: json["users"],
        draw: json["draw"],
        columns: json["columns"] == null
            ? null
            : List<ColumnData>.from(
                json["columns"].map((x) => ColumnData.fromJson(x))),
        order: json["order"] == null
            ? null
            : List<OrderData>.from(
                json["order"].map((x) => OrderData.fromJson(x))),
        start: json["start"],
        length: json["length"],
        search:
            json["search"] == null ? null : SearchData.fromJson(json["search"]),
        empty: json["_"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "users": users,
        "draw": draw,
        "columns": columns == null
            ? null
            : List<dynamic>.from(columns!.map((x) => x!.toJson())),
        "order": order == null
            ? null
            : List<dynamic>.from(order!.map((x) => x!.toJson())),
        "start": start,
        "length": length,
        "search": search == null ? null : search!.toJson(),
        "_": empty,
      };
}
