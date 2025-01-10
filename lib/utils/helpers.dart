import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
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

  static String capitalizeFirstLetter(String text) {
    String capitalizedString =
        text.split(' ').map((word) => word.capitalize!).join(' ');
    return capitalizedString;
  }

  static DateTime getLastSundayDate() {
    DateTime today = DateTime.now();

    if (today.weekday == DateTime.sunday) {
      return today;
    }

    int daysToLastSunday = today.weekday;
    DateTime lastSunday = today.subtract(Duration(days: daysToLastSunday));

    return lastSunday;
  }

  static DateTime getNextSaturday() {
    DateTime today = DateTime.now();
    int daysUntilSaturday = (DateTime.saturday - today.weekday) % 7;
    return today.add(Duration(days: daysUntilSaturday));
  }

  static DateTime getFirstDayOfCurrentMonth() {
    final now = DateTime.now();

    if (now.day == 1) {
      return now;
    }

    return DateTime(now.year, now.month, 1);
  }

  static DateTime getLastDayOfCurrentMonth() {
    final today = DateTime.now();

    if (today.day == DateTime(today.year, today.month + 1, 0).day) {
      return today;
    }

    return DateTime(today.year, today.month + 1, 0);
  }

  static DateTime getFirstDayOfLastMonth() {
    DateTime now = DateTime.now();
    DateTime firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
    return firstDayOfLastMonth;
  }

  static DateTime getLastDayOfLastMonth() {
    DateTime now = DateTime.now();

    DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);

    DateTime lastDayOfLastMonth =
        firstDayOfCurrentMonth.subtract(Duration(days: 1));

    return lastDayOfLastMonth;
  }

  static DateTime convert12HourTimeStringToDateTime(String time, DateTime date) {
    final parts = time.split(' ');
    final hourMinute = parts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);

    if (parts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (parts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
