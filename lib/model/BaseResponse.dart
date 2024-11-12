class BaseResponse<T> {
  BaseResponse({
    //this.data,
    this.message,
    required this.errorList,
  });

  String? message;
  List<String> errorList = [];
  //BaseEntity data;

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        message: json["Message"],
        errorList: List<String>.from(json["ErrorList"].map((x) => x)),
        //data: data.fromJson(json["data"])
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "ErrorList": List<dynamic>.from(errorList.map((x) => x)),
      };

  String getFormattedErrorMsg() {
    var msg = "";

    errorList.forEach((element) {
      msg = msg + " " + element + "\n";
    });

    return msg.trimRight();
  }
}

class BaseEntity {
  BaseEntity();
  factory BaseEntity.fromJson(Map<String, dynamic> json) => BaseEntity();
}
