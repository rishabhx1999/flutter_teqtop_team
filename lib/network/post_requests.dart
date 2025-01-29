import 'package:teqtop_team/model/dashboard/create_comment_res_model.dart';
import 'package:teqtop_team/model/dashboard/edit_post_res_model.dart';
import 'package:teqtop_team/model/dashboard/toggle_like_res_model.dart';
import 'package:teqtop_team/model/dashboard/comments_res_model.dart';
import 'package:teqtop_team/model/dashboard/create_post_res_model.dart';
import 'package:teqtop_team/model/dashboard/feed_res_model.dart';
import 'package:teqtop_team/model/dashboard/upload_file_res_model.dart';
import 'package:teqtop_team/model/drive_detail/add_drive_files_res_model.dart';
import 'package:teqtop_team/model/drive_detail/create_drive_folder_res_model.dart';
import 'package:teqtop_team/model/edit_profile/edit_profile_res_model.dart';
import 'package:teqtop_team/model/login/login_res_model.dart';
import 'package:teqtop_team/model/project_create_edit/create_project_res_model.dart';
import 'package:teqtop_team/model/task_create_edit/create_task_res_model.dart';
import 'package:teqtop_team/model/task_create_edit/edit_task_res_model.dart';
import 'package:teqtop_team/model/task_detail/create_task_comment_res_model.dart';
import 'package:teqtop_team/model/task_detail/task_comments_res_model.dart';
import 'package:teqtop_team/network/api_urls.dart';
import 'package:teqtop_team/network/remote_services.dart';
import 'package:teqtop_team/utils/helpers.dart';
import 'package:http/http.dart' as http;

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

  static Future<UploadFileResModel?> uploadFile(
      http.MultipartFile? uploadMedia, Map<String, dynamic> requestBody) async {
    var apiResponse = await RemoteService.simplePostWithSingleMedia(
        ApiUrls.addPic,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody,
        uploadMedia: uploadMedia);

    if (apiResponse != null) {
      return uploadFileResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<CreatePostResModel?> createPost(
      Map<String, dynamic> requestBody) async {
    var apiResponse = await RemoteService.simplePost(ApiUrls.feedsAdd,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return createPostResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ToggleLikeResModel?> toggleLike(
      Map<String, dynamic> requestBody) async {
    var apiResponse = await RemoteService.simplePost(ApiUrls.like,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return toggleLikeResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<EditProfileResModel?> editProfile(
      {http.MultipartFile? uploadMedia,
      required Map<String, dynamic> requestBody,
      required int profileId}) async {
    var apiResponse = await RemoteService.simplePostWithSingleMediaAndQueries(
        "user/profile/$profileId/update",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody,
        uploadMedia: uploadMedia);

    if (apiResponse != null) {
      return editProfileResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<CreateProjectResModel?> createProject(
      Map<String, dynamic> requestBody) async {
    Helpers.printLog(description: "POST_REQUESTS_CREATE_PROJECT_REACHED");
    var apiResponse = await RemoteService.simplePost(
      ApiUrls.projects,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json;charset=utf-8"
      },
      requestBody: requestBody,
    );

    if (apiResponse != null) {
      return createProjectResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<CreateTaskResModel?> createTask(
      Map<String, dynamic> requestBody) async {
    Helpers.printLog(description: "POST_REQUESTS_CREATE_TASK_REACHED");
    var apiResponse = await RemoteService.simplePost(
      ApiUrls.tasksAdd,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json;charset=utf-8"
      },
      requestBody: requestBody,
    );

    if (apiResponse != null) {
      return createTaskResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<FeedResModel?> deletePost(
      Map<String, dynamic> requestBody) async {
    var apiResponse = await RemoteService.simplePost(ApiUrls.feedsDelete,
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

  static Future<EditPostResModel?> editPost(
      Map<String, dynamic> requestBody, int postId) async {
    var apiResponse = await RemoteService.simplePost(
        "${ApiUrls.feedsEdit}/$postId",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return editPostResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<CreateCommentResModel?> createComment(
      Map<String, dynamic> requestBody) async {
    var apiResponse = await RemoteService.simplePost(ApiUrls.commentAdd,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return createCommentResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<EditTaskResModel?> editTask(
      Map<String, dynamic> requestBody) async {
    Helpers.printLog(description: "POST_REQUESTS_EDIT_TASK_REACHED");
    var apiResponse = await RemoteService.simplePostWithQueries(
      ApiUrls.tasksUpdate,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json;charset=utf-8"
      },
      requestBody: requestBody,
    );

    if (apiResponse != null) {
      return editTaskResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<TaskCommentsResModel?> getTaskComments(
      Map<String, dynamic> requestBody) async {
    Helpers.printLog(description: "POST_REQUESTS_GET_TASK_COMMENTS_REACHED");
    var apiResponse = await RemoteService.simplePost(
      ApiUrls.commentMore,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json;charset=utf-8"
      },
      requestBody: requestBody,
    );

    if (apiResponse != null) {
      return taskCommentsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<CreateTaskCommentResModel?> createTaskComment(
      Map<String, dynamic> requestBody) async {
    Helpers.printLog(description: "POST_REQUESTS_CREATE_TASK_COMMENT_REACHED");
    var apiResponse = await RemoteService.simplePost(
      ApiUrls.commentAdd,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json;charset=utf-8"
      },
      requestBody: requestBody,
    );

    if (apiResponse != null) {
      return createTaskCommentResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<CreateDriveFolderResModel?> createDriveFolder(
      Map<String, dynamic> requestBody) async {
    Helpers.printLog(description: "POST_REQUESTS_CREATE_DRIVE_FOLDER_REACHED");
    var apiResponse = await RemoteService.simplePost(
      ApiUrls.drivesFolderAdd,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json;charset=utf-8"
      },
      requestBody: requestBody,
    );

    if (apiResponse != null) {
      return createDriveFolderResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<AddDriveFilesResModel?> addDriveFiles(
      {required List<String> files, required String parentURL}) async {
    var apiResponse = await RemoteService.addDriveFiles(
        paths: files,
        endUrl: ApiUrls.drivesAdd,
        parentURL: parentURL,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        });

    if (apiResponse != null) {
      return addDriveFilesResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }
}
