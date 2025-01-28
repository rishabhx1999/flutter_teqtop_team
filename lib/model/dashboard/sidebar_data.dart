class SidebarData {
  int? totalUsers;
  int? ongoing;
  int? assisting;
  int? creator;
  int? following;

  SidebarData({
    this.totalUsers,
    this.ongoing,
    this.assisting,
    this.creator,
    this.following,
  });

  factory SidebarData.fromJson(Map<String, dynamic> json) => SidebarData(
    totalUsers: json["total_users"],
    ongoing: json["ongoing"],
    assisting: json["assisting"],
    creator: json["creator"],
    following: json["following"],
  );

  Map<String, dynamic> toJson() => {
    "total_users": totalUsers,
    "ongoing": ongoing,
    "assisting": assisting,
    "creator": creator,
    "following": following,
  };
}