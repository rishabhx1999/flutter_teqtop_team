class OrderData {
  String? column;
  String? dir;

  OrderData({
    this.column,
    this.dir,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      OrderData(
        column: json["column"],
        dir: json["dir"],
      );

  Map<String, dynamic> toJson() => {
        "column": column,
        "dir": dir,
      };
}
