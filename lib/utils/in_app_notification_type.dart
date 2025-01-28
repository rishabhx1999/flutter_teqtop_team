enum InAppNotificationType { project, task, leave, hiring }

final notificationTypeValues = EnumValues({
  "project": InAppNotificationType.project,
  "task": InAppNotificationType.task,
  "leave": InAppNotificationType.leave,
  "hiring": InAppNotificationType.hiring
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
