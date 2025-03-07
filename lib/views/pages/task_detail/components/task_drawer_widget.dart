import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';
import 'package:teqtop_team/views/pages/task_detail/components/concerned_person_widget.dart';

class TaskDrawerWidget extends StatelessWidget {
  final Rx<EmployeeModel?> responsiblePerson;
  final RxList<EmployeeModel?> participants;
  final RxList<EmployeeModel?> observers;

  const TaskDrawerWidget(
      {super.key,
      required this.responsiblePerson,
      required this.participants,
      required this.observers});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 304,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 68,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28, right: 16),
            child: Text(
              "${'created_by'.tr}:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(left: 28, right: 16),
              child: ConcernedPersonWidget(
                personData: responsiblePerson.value ?? EmployeeModel(),
              ),
            ),
          ),
          const SizedBox(
            height: 26,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.black.withValues(alpha: 0.2),
            indent: 28,
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28, right: 16),
            child: Text(
              "${'responsible_person'.tr}:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(left: 28, right: 16),
              child: ConcernedPersonWidget(
                personData: responsiblePerson.value ?? EmployeeModel(),
              ),
            ),
          ),
          const SizedBox(
            height: 26,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.black.withValues(alpha: 0.2),
            indent: 28,
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28, right: 16),
            child: Text(
              "${'participants'.tr}:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Obx(
            () => ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 28, right: 16),
                itemBuilder: (context, index) {
                  return ConcernedPersonWidget(
                    personData: participants[index] ?? EmployeeModel(),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: participants.length),
          ),
          const SizedBox(
            height: 26,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.black.withValues(alpha: 0.2),
            indent: 28,
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28, right: 16),
            child: Text(
              "${'observer'.tr}:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Obx(
            () => ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 28, right: 16),
                itemBuilder: (context, index) {
                  return ConcernedPersonWidget(
                    personData: observers[index] ?? EmployeeModel(),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: observers.length),
          ),
          const SizedBox(
            height: 68,
          ),
        ],
      ),
    );
  }
}
