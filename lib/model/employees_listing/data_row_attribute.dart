import '../enum_values.dart';

class DataRowAttribute {
  Style? style;

  DataRowAttribute({
    this.style,
  });

  factory DataRowAttribute.fromJson(Map<String, dynamic> json) => DataRowAttribute(
        style: json["style"] == null ? null : styleValues.map[json["style"]],
      );

  Map<String, dynamic> toJson() => {
        "style": styleValues.reverse[style],
      };
}

enum Style { BACKGROUND_COLOR_F5_C1_C1, EMPTY }

final styleValues = EnumValues({
  "background-color: #f5c1c1;": Style.BACKGROUND_COLOR_F5_C1_C1,
  "": Style.EMPTY
});
