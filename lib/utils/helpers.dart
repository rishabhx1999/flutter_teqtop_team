import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'dart:typed_data' as typed_data;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:teqtop_team/utils/preference_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_compress/video_compress.dart';

import '../model/media_content_model.dart';
import '../network/post_requests.dart';

class Helpers {
  Helpers._();

  static void printLog({required String description, String? message}) {
    if (AppConsts.isDebug) {
      const int chunkSize = 800;
      String logHeader = "$description ===== ";

      if (message != null && message.length > chunkSize) {
        debugPrint(logHeader);
        for (int i = 0; i < message.length; i += chunkSize) {
          debugPrint(message.substring(i,
              i + chunkSize > message.length ? message.length : i + chunkSize));
        }
        debugPrint("-----ENDS_HERE-----");
      } else {
        debugPrint("$logHeader$message \n-----ENDS_HERE-----");
      }
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

  static bool isMedia(String file) {
    return isImage(file) || isVideo(file);
  }

  static bool isImage(String file) {
    return file.endsWith('.jpg') ||
        file.endsWith('.jpeg') ||
        file.endsWith('.png') ||
        file.endsWith('.gif') ||
        file.endsWith('.bmp') ||
        file.endsWith('.svg') ||
        file.endsWith('.heic') ||
        file.endsWith('.heif');
  }

  static bool isVideo(String file) {
    return file.endsWith('.mp4') ||
        file.endsWith('.mov') ||
        file.endsWith('.avi') ||
        file.endsWith('.mkv') ||
        file.endsWith('.flv') ||
        file.endsWith('.wmv') ||
        file.endsWith('.webm');
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
        firstDayOfCurrentMonth.subtract(const Duration(days: 1));

    return lastDayOfLastMonth;
  }

  static DateTime convert12HourTimeStringToDateTime(
      String time, DateTime date) {
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

  static String convertToHTMLParagraphs(String input) {
    List<String> lines = input.split('\n');

    List<String> wrappedLines = lines.map((line) => '<p>$line</p>').toList();

    return wrappedLines.join();
  }

  static String formatHtmlParagraphs(String htmlString) {
    html_dom.Document document = parse(htmlString);

    final paragraphs = document.getElementsByTagName('p');

    final lines = paragraphs.map((p) {
      String text = p.text.trim();
      return text.isNotEmpty ? text : '';
    }).toList();

    return lines.join('\n');
  }

  static String updateImgStyles(String htmlString) {
    var document = html_parser.parse(htmlString);

    for (var img in document.getElementsByTagName('img')) {
      img.attributes.remove('style');

      img.attributes['style'] = 'max-width: 100%;';
    }

    return document.body?.innerHtml ?? htmlString;
  }

  static void applyClassToPureTextElements(
      html_dom.Element element, String className) {
    bool isPureText =
        element.children.isEmpty && element.text.trim().isNotEmpty;

    if (isPureText && !element.classes.contains(className)) {
      element.classes.add(className);
    } else {
      for (var child in element.children) {
        applyClassToPureTextElements(child, className);
      }
    }
  }

  static String applySelectableCopyableClassToPureTextElements(
      String htmlContent) {
    html_dom.Document document = html_parser.parse(htmlContent);

    for (var element in document.body?.children ?? []) {
      applyClassToPureTextElements(element, "selectable-copyable");
    }

    return document.body?.innerHtml ?? '';
  }

  static List<String> extractFilesURLs(String input) {
    if (input.startsWith('[') && input.endsWith(']')) {
      return input
          .substring(1, input.length - 1)
          .split(RegExp(r',(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)'))
          .map((e) => e.trim())
          .map((e) =>
              e.replaceAll(RegExp(r'\\'), '').replaceAll(RegExp(r'^"|"$'), ''))
          .toList();
    } else {
      return [input];
    }
  }

  // static Future<Image> convertFileToImage(File picture) async {
  //   List<int> imageBase64 = picture.readAsBytesSync();
  //   String imageAsString = base64Encode(imageBase64);
  //
  //   typed_data.Uint8List uint8list =
  //       typed_data.Uint8List.fromList(base64.decode(imageAsString));
  //
  //   return Image.memory(uint8list);
  // }

  static Future<void> openFile({required String path, String? fileName}) async {
    final file = await downloadFile(AppConsts.imgInitialUrl + path, fileName!);
    if (file == null) return;
    // Helpers.printLog(
    //     description: "DASHBOARD_CONTROLLER_OPEN_POST_FILE",
    //     message: "DOWNLOADED_FILE_PATH = ${file.path}");
    OpenFile.open(file.path);
  }

  static Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    try {
      final response = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: const Duration(microseconds: 0)));
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

  static String getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      default:
        return 'application/octet-stream';
    }
  }

  static String addUserSelectToTextElements(String htmlString) {
    // Parse the HTML string into a document
    html_dom.Document document = html_parser.parse(htmlString);

    // Find all elements
    document.body?.querySelectorAll('*').forEach((element) {
      // Check if the element contains visible text
      if (element.nodes.any(
          (node) => node is html_dom.Text && node.text.trim().isNotEmpty)) {
        element.attributes['style'] =
            '${element.attributes['style'] ?? ''} user-select: text;';
      }
    });

    // Return the modified HTML as a string
    return document.body!.innerHtml;
  }

  static String updateHtmlAttributes(String htmlContent) {
    html_dom.Document document = html_parser.parse(htmlContent);

    document.querySelectorAll('img').forEach((element) {
      String? src = element.attributes['src'];
      if (src != null && !src.startsWith('http')) {
        element.attributes['src'] = '${AppConsts.imgInitialUrl}$src';
      }
    });

    document.querySelectorAll('a').forEach((element) {
      String? href = element.attributes['href'];
      if (href != null && !href.startsWith('http')) {
        element.attributes['href'] = '${AppConsts.imgInitialUrl}$href';
      }
    });

    return document.body?.innerHtml ?? htmlContent;
  }

  static void openLink(String url) async {
    // Helpers.printLog(description: 'HELPERS_OPEN_LINK', message: 'URL = $url');

    Uri? uri = _getValidUri(url);
    if (uri == null) {
      Get.snackbar("error".tr, "message_invalid_url".tr);
      throw 'Invalid URL: $url';
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("error".tr, "message_invalid_url".tr);
      throw 'Could not launch $url';
    }
  }

  static Uri? _getValidUri(String url) {
    if (!url.contains("://")) {
      Uri httpsUri = Uri.parse("https://$url");
      if (Uri.tryParse(httpsUri.toString()) != null) {
        return httpsUri;
      }

      Uri httpUri = Uri.parse("http://$url");
      if (Uri.tryParse(httpUri.toString()) != null) {
        return httpUri;
      }
    } else {
      return Uri.tryParse(url);
    }
    return null;
  }

  static Future<String> convertImageToDataUrl(XFile file) async {
    try {
      typed_data.Uint8List bytes = await file.readAsBytes();

      String base64String = base64Encode(bytes);

      String extension = file.path.split('.').last;

      String mimeType = getMimeType(extension);

      return 'data:$mimeType;base64,$base64String';
    } catch (e) {
      // printLog(
      //     description: 'HELPERS_CONVERT_IMAGE_TO_DATA_URL',
      //     message: 'ERROR CONVERTING IMAGE TO DATA URL: $e');
      return '';
    }
  }

  static String extensionFromMimeType(String mimeType) {
    switch (mimeType.toLowerCase()) {
      case 'image/jpeg':
        return 'jpg';
      case 'image/png':
        return 'png';
      case 'image/gif':
        return 'gif';
      case 'image/bmp':
        return 'bmp';
      case 'image/svg+xml':
        return 'svg';
      default:
        return 'bin'; // fallback
    }
  }

  static Future<File?> convertDataUrlToFile(String dataUrl) async {
    try {
      final regex = RegExp(r'data:(.*);base64,(.*)');
      final match = regex.firstMatch(dataUrl);

      if (match == null) return null;

      final mimeType = match.group(1);
      final base64String = match.group(2);
      if (mimeType == null || base64String == null) return null;

      String ext = extensionFromMimeType(mimeType);
      String? fileName = "file_${DateTime.now().millisecondsSinceEpoch}.$ext";

      final typed_data.Uint8List bytes = base64Decode(base64String);

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      debugPrint("Error converting Data URL to File: $e");
      return null;
    }
  }

  static bool isBase64DataUrl(String input) {
    // This regex checks for the Data URL scheme with base64 encoding.
    final regex = RegExp(r'^data:(.*);base64,(.*)$');
    return regex.hasMatch(input);
  }

  static Future<List<MediaContentModel>> convertHTMLToMultimediaContent(
      String html) async {
    List<MediaContentModel> mediaList = [];

    if (!html.contains(RegExp(r'<[^>]+>'))) {
      mediaList.add(MediaContentModel(text: html.trim()));
      return mediaList;
    }

    var document =
        html_parser.parse(html.replaceAll(r'\"', '"').replaceAll(r'\\', ''));

    for (var element in document.body!.children) {
      if (element.localName == 'p' || element.localName == 'div') {
        if (element.children.isEmpty) {
          mediaList.add(MediaContentModel(text: element.text));
        } else {
          if (element.children.any((child) =>
              child.localName == 'b' && child.classes.contains('dx-mention'))) {
            String extractedText = element.text.trim();
            mediaList.add(MediaContentModel(text: extractedText));
          } else {
            var child = element.children.first;
            if (child.localName == 'img' &&
                child.attributes.containsKey('src')) {
              mediaList.add(MediaContentModel(
                  imageString: child.attributes['src']!
                      .replaceAll(r'\"', '"')
                      .replaceAll(r'\\', '')));
            } else if (child.localName == 'a' &&
                child.attributes.containsKey('href')) {
              mediaList.add(MediaContentModel(
                  fileString: child.attributes['href']!
                      .replaceAll(r'\"', '"')
                      .replaceAll(r'\\', '')));
            }
          }
        }
      }
    }

    return mediaList;
  }

  static Future<String?> uploadFile(String filePath, String? fileType) async {
    // printLog(description: "HELPERS_UPLOAD_FILE_STARTED");
    File file = File(filePath);

    File finalFile = File(filePath);

    if (isImage(filePath)) {
      finalFile = await compressImageIfNeeded(file);
    } else if (isVideo(filePath)) {
      finalFile = await compressVideoIfNeeded(file);
    }

    if (await isInternetWorking()) {
      var uploadMedia =
          await http.MultipartFile.fromPath('data_file', finalFile.path);
      Map<String, dynamic> requestBody = {
        'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
            as String?,
        'extension': fileType ?? '',
        'data_file': '(binary)',
        '_comp': 'feed',
        'format': 'application'
      };

      var response = await PostRequests.uploadFile(uploadMedia, requestBody);
      if (response != null) {
        return response.src;
      } else {
        Get.snackbar('error'.tr, 'message_server_error'.tr);
      }
    } else {
      Get.snackbar("error".tr, "message_check_internet".tr);
    }
    return null;
  }

  static String mentionPersonInHTML(String input, String name, String id) {
    String replacement =
        '<span class="dx-mention" contenteditable="false" spellcheck="false" data-marker="@" data-mention-value="$name" data-id="$id"><span contenteditable="false"><span>@</span>$name</span></span>&nbsp;';

    int lastIndex = input.lastIndexOf('@#');
    if (lastIndex == -1) return input;

    return input.substring(0, lastIndex) +
        replacement +
        input.substring(lastIndex + 2);
  }

  static String updateDxMentionSpans(String htmlString) {
    html_dom.Document document = html_parser.parse(htmlString);

    document.querySelectorAll('span.dx-mention').forEach((span) {
      if (span.attributes['contenteditable'] != 'false') {
        span.attributes['contenteditable'] = 'false';
      }
    });

    return document.body!.innerHtml;
  }

  static Future<void> downloadFileInDownloads(
      {required String remoteEndPath}) async {
    try {
      var time = DateTime.now().millisecondsSinceEpoch;
      var devicePath =
          "/storage/emulated/0/Download/$time.${extension(remoteEndPath).replaceFirst('.', '')}";
      var file = File(devicePath);

      var response =
          await http.get(Uri.parse(AppConsts.imgInitialUrl + remoteEndPath));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);

        if (await file.exists()) {
          Get.snackbar("success".tr,
              "Please check $time.${extension(remoteEndPath).replaceFirst('.', '')} in downloads.");
        } else {
          Get.snackbar("error".tr, "message_download_failed".tr);
        }
      } else {
        Get.snackbar("error".tr, "message_download_failed".tr);
      }
    } catch (e) {
      printLog(
          description: "HELPERS_DOWNLOAD_FILE_IN_DOWNLOADS",
          message: "ERROR = ${e.toString()}");
    }
  }

  static String cleanMentions(String htmlContent) {
    RegExp mentionRegex = RegExp(
        r'(<span class="dx-mention"[^>]*?>.*?<\/span>)([^<]*)',
        caseSensitive: false,
        dotAll: true);

    StringBuffer cleanedHtml = StringBuffer();
    int lastMatchEnd = 0;

    mentionRegex.allMatches(htmlContent).forEach((match) {
      String mention = match.group(1)!; // Properly formatted mention
      String extraText =
          match.group(2)!.trim(); // Extra text that shouldn't be here

      // Append everything before the match
      cleanedHtml.write(htmlContent.substring(lastMatchEnd, match.start));

      // Append mention first
      cleanedHtml.write(mention);

      // Move extra text before or after mentions
      if (extraText.isNotEmpty) {
        cleanedHtml.write(" " + extraText);
      }

      lastMatchEnd = match.end;
    });

    // Append any remaining part of the content
    cleanedHtml.write(htmlContent.substring(lastMatchEnd));

    return cleanedHtml.toString();
  }

  static Future<File> compressImageIfNeeded(File file) async {
    int maxSize = 512 * 1024;

    if (file.lengthSync() > maxSize) {
      // printLog(
      //     description: "HELPERS_COMPRESS_IF_NEEDED",
      //     message: "FILE_SIZE = ${file.lengthSync()}");
      file = await compressImage(file);
    }
    return file;
  }

  static Future<File> compressVideoIfNeeded(File file) async {
    int maxSize = 1024 * 1024;
    int maxSize2 = 5 * 1024 * 1024;

    if (file.lengthSync() > maxSize2) {
      // printLog(
      //     description: "HELPERS_COMPRESS_IF_NEEDED",
      //     message: "FILE_SIZE = ${file.lengthSync()}");
      file = await compressVideo(file, videoQuality: VideoQuality.LowQuality);
    }
    if (file.lengthSync() > maxSize) {
      file = await compressVideo(file);
    }
    return file;
  }

  static Future<File> compressVideo(File file,
      {VideoQuality videoQuality = VideoQuality.MediumQuality}) async {
    try {
      final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
        file.path,
        quality: videoQuality,
        deleteOrigin: false,
      );

      return compressedVideo?.file ?? file;
    } catch (e) {
      printLog(
          description: "HELPERS_COMPRESS_VIDEO",
          message: "ERROR COMPRESSING VIDEO: $e");
      return file;
    }
  }

  static Future<File> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = join(dir.path, "compressed_${basename(file.path)}");

    XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );

    return File(compressedXFile?.path ?? file.path);
  }

  static Future<String> convertMultimediaContentToHTML(
      List<MediaContentModel> content,
      {bool addDecode = false}) async {
    List<String> htmlParts = [];

    for (var media in content) {
      if (media.text != null) {
        htmlParts.add("<p>${media.text}</p>");
      } else if (media.image != null) {
        // String? imageUrl = await Helpers.convertImageToDataUrl(media.image!);
        String? imageUrl = await uploadFile(media.image!.path, null);
        if (imageUrl != null && imageUrl.isNotEmpty) {
          htmlParts.add(addDecode
              ? '<p><img src="$imageUrl"  class="decode"></p>'
              : '<p><img src="$imageUrl"></p>');
        }
      } else if (media.imageString != null && media.imageString!.isNotEmpty) {
        htmlParts.add(addDecode
            ? '<p><img src="${media.imageString}"  class="decode"></p>'
            : '<p><img src="${media.imageString}"></p>');
      } else if (media.file != null && media.file!.path != null) {
        String? fileUrl =
            await uploadFile(media.file!.path!, media.file!.extension);
        if (fileUrl != null && fileUrl.isNotEmpty) {
          htmlParts.add(
              '<p><a href="$fileUrl" rel="noopener noreferrer">${media.file!.name}</a></p>');
        }
      } else if (media.fileString != null && media.fileString!.isNotEmpty) {
        htmlParts.add(
            '<p><a href="${media.fileString}" rel="noopener noreferrer">${media.fileString}</a></p>');
      }
    }

    return htmlParts.join("").replaceAll('"', r'\"');
  }

  static Future<bool> isInternetWorking() async {
    try {
      final result = await InternetAddress.lookup('teqtop.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (e) {
      printLog(
          description: "HELPERS_IS_INTERNET_WORKING",
          message: "ERROR = ${e.toString()}");
    }
    return false;
  }
}
