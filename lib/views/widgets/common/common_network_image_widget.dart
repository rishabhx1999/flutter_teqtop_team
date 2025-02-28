import 'package:flutter/cupertino.dart';

import '../../../consts/app_images.dart';

class CommonNetworkImageWidget extends StatefulWidget {
  final String imageUrl;
  final double height;

  const CommonNetworkImageWidget(
      {required this.imageUrl, this.height = 250, Key? key})
      : super(key: key);

  @override
  _CustomNetworkImageState createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CommonNetworkImageWidget> {
  late Future<ImageProvider> _imageLoader;

  @override
  void initState() {
    super.initState();
    _imageLoader = _loadImage(widget.imageUrl);
  }

  Future<ImageProvider> _loadImage(String url) async {
    try {
      final image = NetworkImage(url);
      await precacheImage(image, context);
      return image;
    } catch (e) {
      return AssetImage(AppImages.imgPlaceholder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider>(
      future: _imageLoader,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Image(
            image: snapshot.data!,
            height: widget.height,
            fit: BoxFit.contain,
          );
        } else {
          return Image.asset(
            AppImages.imgPlaceholder,
            height: widget.height,
            fit: BoxFit.contain,
          );
        }
      },
    );
  }
}
