import 'package:flutter/cupertino.dart';
import 'package:teqtop_team/model/dashboard/post_image_model.dart';

class PostMediaModel {
  int postId;
  List<PostImageModel> images;
  List<String> documents;
  PageController pageController;

  PostMediaModel(
      {required this.postId,
      required this.images,
      required this.documents,
      required this.pageController});
}
