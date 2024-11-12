class DashboardResponse {
  DashboardResponse({
    required this.data,
    required this.message,
    required this.errorList,
  });

  late DashboardResponseData data;
  late String message;
  late List<String> errorList;
  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      DashboardResponse(
        data: json["Data"] == null
            ? DashboardResponseData(
                IsRefrenceInAllowed: false,
                IsShowDataAllowed: false,
                IsShowListAllowed: false,
                IsSubReferenceAllowed: false)
            : DashboardResponseData.fromJson(json["Data"]),
        message: json["Message"] == null ? "" : json["Message"],
        errorList: List<String>.from(json["ErrorList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Data": data.toJson(),
        "Message": message,
        "ErrorList": List<dynamic>.from(errorList.map((x) => x)),
      };
}

class DashboardResponseData {
  //

  String? userType;
  String? image;
  String? fullName;
  var totalCapital;
  int? NotificationCount;
  var UserName;

  bool IsRefrenceInAllowed = false;

  bool? IsSubReferenceAllowed = false;

  bool? IsShowListAllowed = false;

  bool? IsShowDataAllowed = false;

  DashboardResponseData(
      {this.userType,
      this.image,
      this.fullName,
      this.totalCapital,
      this.NotificationCount,
      this.UserName,
      required this.IsRefrenceInAllowed,
      this.IsShowDataAllowed,
      this.IsShowListAllowed,
      this.IsSubReferenceAllowed});

  DashboardResponseData.fromJson(Map<String, dynamic> json) {
    userType = json['UserType'];
    image = json['Image'];
    fullName = json['FullName'];
    totalCapital = json['TotalCapital'];
    NotificationCount = json['NotificationCount'];
    UserName = json['UserName'];
    IsRefrenceInAllowed = json['IsRefrenceInAllowed'];
    IsSubReferenceAllowed = json['IsSubReferenceAllowed'];
    IsShowListAllowed = json['IsShowListAllowed'];
    IsShowDataAllowed = json['IsShowDataAllowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserType'] = this.userType;
    data['Image'] = this.image;
    data['FullName'] = this.fullName;
    data['TotalCapital'] = this.totalCapital;
    data['NotificationCount'] = this.NotificationCount;
    data['UserName'] = this.UserName;
    data['IsRefrenceInAllowed'] = this.IsRefrenceInAllowed;
    data['IsSubReferenceAllowed'] = this.IsSubReferenceAllowed;
    data['IsShowListAllowed'] = this.IsShowListAllowed;
    data['IsShowDataAllowed'] = this.IsShowDataAllowed;
    return data;
  }
}
