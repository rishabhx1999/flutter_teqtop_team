import '../media_content_model.dart';
import 'comment_count.dart';
import 'comment_list.dart';
import 'like_user.dart';

class FeedModel {
  int? id;
  int? userId;
  String? description;
  dynamic files;
  dynamic pins;
  String? status;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? userName;
  String? userProfile;
  int? likedBy;
  List<CommentCount?>? commentCount;
  List<CommentList?>? commentList;
  List<LikeUser?>? likeUsers;
  List<MediaContentModel> feedItems = [];

  FeedModel({
    this.id,
    this.userId,
    this.description,
    this.files,
    this.pins,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.userProfile,
    this.likedBy,
    this.commentCount,
    this.commentList,
    this.likeUsers,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
        id: json["id"],
        userId: json["user_id"],
        description: json["description"],
        files: json["files"],
        pins: json["pins"],
        status: json["status"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userName: json["user_name"],
        userProfile: json["user_profile"],
        likedBy: json["liked_by"],
        commentCount: json["comment_count"] == null
            ? null
            : List<CommentCount>.from(
                json["comment_count"].map((x) => CommentCount.fromJson(x))),
        commentList: json["comment_list"] == null
            ? null
            : List<CommentList>.from(
                json["comment_list"].map((x) => CommentList.fromJson(x))),
        likeUsers: json["like_users"] == null
            ? null
            : List<LikeUser>.from(
                json["like_users"].map((x) => LikeUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "description": description,
        "files": files,
        "pins": pins,
        "status": status,
        "deleted_at": deletedAt,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "user_name": userName,
        "user_profile": userProfile,
        "liked_by": likedBy,
        "comment_count": commentCount == null
            ? null
            : List<dynamic>.from(commentCount!.map((x) => x!.toJson())),
        "comment_list": commentList == null
            ? null
            : List<dynamic>.from(commentList!.map((x) => x!.toJson())),
        "like_users": likeUsers == null
            ? null
            : List<dynamic>.from(likeUsers!.map((x) => x!.toJson())),
      };
}
