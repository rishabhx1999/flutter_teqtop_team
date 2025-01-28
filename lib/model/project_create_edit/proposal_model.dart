class ProposalModel {
  int? id;
  int? userId;
  int? portalId;
  int? profileId;
  int? clientId;
  int? category;
  int? period;
  String? companyId;
  dynamic contributorId;
  String? title;
  String? link;
  dynamic url;
  dynamic description;
  String? proposal;
  String? currency;
  String? cost;
  String? calculatedCost;
  String? recievedAmount;
  dynamic refundAmount;
  dynamic refundCost;
  String? calculatedAmount;
  String? estimatedHours;
  dynamic clientCountry;
  String? isInvite;
  dynamic notes;
  String? media;
  String? connects;
  String? hours;
  String? status;
  String? queries;
  String? activate;
  DateTime? refundDate;
  DateTime? amountDate;
  dynamic callDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic newStatusDate;
  DateTime? hiredStatusDate;
  dynamic discussStatusDate;
  dynamic completeStatusDate;
  dynamic rejectStatusDate;
  dynamic followStatusDate;
  dynamic pauseStatusDate;
  dynamic spamStatusDate;
  dynamic userIncentiveMonth;
  dynamic contributeIncentiveMonth;
  int? userIncentiveCount;
  int? contriIncentiveCount;

  ProposalModel({
    this.id,
    this.userId,
    this.portalId,
    this.profileId,
    this.clientId,
    this.category,
    this.period,
    this.companyId,
    this.contributorId,
    this.title,
    this.link,
    this.url,
    this.description,
    this.proposal,
    this.currency,
    this.cost,
    this.calculatedCost,
    this.recievedAmount,
    this.refundAmount,
    this.refundCost,
    this.calculatedAmount,
    this.estimatedHours,
    this.clientCountry,
    this.isInvite,
    this.notes,
    this.media,
    this.connects,
    this.hours,
    this.status,
    this.queries,
    this.activate,
    this.refundDate,
    this.amountDate,
    this.callDate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.newStatusDate,
    this.hiredStatusDate,
    this.discussStatusDate,
    this.completeStatusDate,
    this.rejectStatusDate,
    this.followStatusDate,
    this.pauseStatusDate,
    this.spamStatusDate,
    this.userIncentiveMonth,
    this.contributeIncentiveMonth,
    this.userIncentiveCount,
    this.contriIncentiveCount,
  });

  factory ProposalModel.fromJson(Map<String, dynamic> json) => ProposalModel(
        id: json["id"],
        userId: json["user_id"],
        portalId: json["portal_id"],
        profileId: json["profile_id"],
        clientId: json["client_id"],
        category: json["category"],
        period: json["period"],
        companyId: json["company_id"],
        contributorId: json["contributor_id"],
        title: json["title"],
        link: json["link"],
        url: json["url"],
        description: json["description"],
        proposal: json["proposal"],
        currency: json["currency"],
        cost: json["cost"],
        calculatedCost: json["calculated_cost"],
        recievedAmount: json["recieved_amount"],
        refundAmount: json["refund_amount"],
        refundCost: json["refund_cost"],
        calculatedAmount: json["calculated_amount"],
        estimatedHours: json["estimated_hours"],
        clientCountry: json["client_country"],
        isInvite: json["is_invite"],
        notes: json["notes"],
        media: json["media"],
        connects: json["connects"],
        hours: json["hours"],
        status: json["status"],
        queries: json["queries"],
        activate: json["activate"],
        refundDate: json["refund_date"] == null
            ? null
            : DateTime.parse(json["refund_date"]),
        amountDate: json["amount_date"] == null
            ? null
            : DateTime.parse(json["amount_date"]),
        callDate: json["call_date"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        newStatusDate: json["newStatusDate"],
        hiredStatusDate: json["hiredStatusDate"] == null
            ? null
            : DateTime.parse(json["hiredStatusDate"]),
        discussStatusDate: json["discussStatusDate"],
        completeStatusDate: json["completeStatusDate"],
        rejectStatusDate: json["rejectStatusDate"],
        followStatusDate: json["followStatusDate"],
        pauseStatusDate: json["pauseStatusDate"],
        spamStatusDate: json["spamStatusDate"],
        userIncentiveMonth: json["userIncentiveMonth"],
        contributeIncentiveMonth: json["contributeIncentiveMonth"],
        userIncentiveCount: json["userIncentiveCount"],
        contriIncentiveCount: json["contriIncentiveCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "portal_id": portalId,
        "profile_id": profileId,
        "client_id": clientId,
        "category": category,
        "period": period,
        "company_id": companyId,
        "contributor_id": contributorId,
        "title": title,
        "link": link,
        "url": url,
        "description": description,
        "proposal": proposal,
        "currency": currency,
        "cost": cost,
        "calculated_cost": calculatedCost,
        "recieved_amount": recievedAmount,
        "refund_amount": refundAmount,
        "refund_cost": refundCost,
        "calculated_amount": calculatedAmount,
        "estimated_hours": estimatedHours,
        "client_country": clientCountry,
        "is_invite": isInvite,
        "notes": notes,
        "media": media,
        "connects": connects,
        "hours": hours,
        "status": status,
        "queries": queries,
        "activate": activate,
        "refund_date":
            refundAmount == null ? null : refundDate!.toIso8601String(),
        "amount_date":
            amountDate == null ? null : amountDate!.toIso8601String(),
        "call_date": callDate,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "newStatusDate": newStatusDate,
        "hiredStatusDate":
            hiredStatusDate == null ? null : hiredStatusDate!.toIso8601String(),
        "discussStatusDate": discussStatusDate,
        "completeStatusDate": completeStatusDate,
        "rejectStatusDate": rejectStatusDate,
        "followStatusDate": followStatusDate,
        "pauseStatusDate": pauseStatusDate,
        "spamStatusDate": spamStatusDate,
        "userIncentiveMonth": userIncentiveMonth,
        "contributeIncentiveMonth": contributeIncentiveMonth,
        "userIncentiveCount": userIncentiveCount,
        "contriIncentiveCount": contriIncentiveCount,
      };
}
