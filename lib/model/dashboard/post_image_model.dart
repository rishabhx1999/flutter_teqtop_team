import 'package:flutter/cupertino.dart';

class PostImageModel {
  String image;
  TransformationController transformationController;
  AnimationController animationController;

  PostImageModel(
      {required this.image,
      required this.transformationController,
      required this.animationController});
}
