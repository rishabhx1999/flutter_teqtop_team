import 'package:teqtop_team/model/dashboard/feed_res_model.dart';
import 'package:teqtop_team/model/dashboard/user_res_model.dart';
import 'package:teqtop_team/network/remote_services.dart';

import '../utils/helpers.dart';
import 'api_urls.dart';

class GetRequests {
  GetRequests._();

  static Future<FeedResModel?> getPosts() async {
    Helpers.printLog(description: "GET_REQUESTS_GET_POSTS_REACHED");
    var apiResponse = await RemoteService.simpleGet(ApiUrls.feeds, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json;charset=utf-8"
    });

    if (apiResponse != null) {
      return feedResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<UserResModel?> getLoggedInUserData() async {
    Helpers.printLog(
        description: "GET_REQUESTS_GET_LOGGED_IN_USER_DATA_REACHED");
    var apiResponse = await RemoteService.simpleGet(ApiUrls.user, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json;charset=utf-8"
    });

    if (apiResponse != null) {
      return userResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }
}
