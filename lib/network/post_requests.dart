import 'package:teqtop_team/model/dashboard/comments_res_model.dart';
import 'package:teqtop_team/model/dashboard/feed_res_model.dart';
import 'package:teqtop_team/model/login/login_res_model.dart';
import 'package:teqtop_team/network/api_urls.dart';
import 'package:teqtop_team/network/remote_services.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../model/global_search/global_search_res_model.dart';

class PostRequests {
  PostRequests._();

  static Future<LoginResModel?> loginUser(
      Map<String, dynamic> requestBody) async {
    Helpers.printLog(description: "POST_REQUESTS_LOGIN_USER_REACHED");
    var apiResponse = await RemoteService.simplePost(ApiUrls.login,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody,
        isLogin: true);

    if (apiResponse != null) {
      return loginResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<FeedResModel?> getMorePosts(
      Map<String, dynamic> requestBody) async {
    var apiResponse = await RemoteService.simplePost(ApiUrls.feedsSearch,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return feedResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<CommentsResModel?> getComments(
      Map<String, dynamic> requestBody) async {
    var apiResponse = await RemoteService.simplePost(ApiUrls.commentFeedsMore,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return commentsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<GlobalSearchResModel?> searchGlobal(
      Map<String, dynamic> requestBody) async {
    var apiResponse = await RemoteService.simplePost(ApiUrls.searchGlobally,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return globalSearchResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }
}
