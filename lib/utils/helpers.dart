import 'package:flutter/cupertino.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart';
import 'package:teqtop_team/consts/app_consts.dart';

class Helpers {
  Helpers._();

  static printLog({required String description, String? message}) {
    if (AppConsts.isDebug) {
      debugPrint("$description ===== $message \n -----ENDS_HERE------");
    }
  }

  static isResponseSuccessful(int code) {
    return code >= 200 && code < 300;
  }

  static String formatTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}y';
    }
  }

  static String cleanHtml(String htmlString) {
    html_dom.Document document = parse(htmlString);

    String cleanedText = document.body?.text ?? '';

    String decodedText = cleanedText.replaceAll(RegExp(r'&\S*;'), ' ');

    return decodedText.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static List<String> extractImages(String htmlString) {
    html_dom.Document document = parse(htmlString);

    List<html_dom.Element> imgElements = document.getElementsByTagName('img');
    List<String> imageUrls = imgElements
        .map((img) => img.attributes['src'] ?? '')
        .where((src) => src.isNotEmpty)
        .toList();

    return imageUrls;
  }

  static bool isImage(String file) {
    return (file.endsWith('.jpg') ||
        file.endsWith('.jpeg') ||
        file.endsWith('.png') ||
        file.endsWith('.gif') ||
        file.endsWith('.bmp') ||
        file.endsWith('.svg'));
  }
}
