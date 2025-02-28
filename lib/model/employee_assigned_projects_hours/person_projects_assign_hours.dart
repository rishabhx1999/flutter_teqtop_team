import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class PersonProjectsAssignHours {
  final int? id;
  final int? projectId;
  final String? projectName;
  final double? assignedHours;
  final double? totalHours;
  final double? weeklyHours;
  RxBool isPaused = false.obs;
  TextEditingController? assignHoursEditingController;

  PersonProjectsAssignHours(
      {this.id,
      this.projectId,
      this.projectName,
      this.assignedHours,
      this.totalHours,
      this.weeklyHours,
      required this.isPaused});
}
