import 'package:get/get_rx/src/rx_types/rx_types.dart';

class FileModel {
  int? id;
  String file;
  RxBool isLoading = false.obs;

  FileModel({
    this.id,
    required this.file,
  });
}
