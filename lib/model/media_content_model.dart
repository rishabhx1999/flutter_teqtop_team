import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class MediaContentModel {
  final String? text;
  final XFile? image;
  final PlatformFile? file;
  final String? imageString;
  final String? fileString;

  MediaContentModel(
      {this.text, this.image, this.file, this.imageString, this.fileString});
}
