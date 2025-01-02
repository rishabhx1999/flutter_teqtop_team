
class CommentCount {
  int? componentId;

  CommentCount({
    this.componentId,
  });

  factory CommentCount.fromJson(Map<String, dynamic> json) => CommentCount(
    componentId: json["component_id"],
  );

  Map<String, dynamic> toJson() => {
    "component_id": componentId,
  };
}