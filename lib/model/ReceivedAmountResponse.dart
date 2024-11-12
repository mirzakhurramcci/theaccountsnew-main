class ReceivedAmountResponse {
  ReceivedAmountResponse({
    required this.data,
    required this.message,
    required this.errorList,
  });

  late ReceivedAmountResponseData data;
  late String message;
  late List<String> errorList;
  factory ReceivedAmountResponse.fromJson(Map<String, dynamic> json) =>
      ReceivedAmountResponse(
        data: json["Data"] == null
            ? ReceivedAmountResponseData()
            : ReceivedAmountResponseData.fromJson(json["Data"]),
        message: json["Message"] == null ? "" : json["Message"],
        errorList: List<String>.from(json["ErrorList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Data": data.toJson(),
        "Message": message,
        "ErrorList": List<dynamic>.from(errorList.map((x) => x)),
      };
}

class ReceivedAmountResponseData {
  var TotalReceived;
  var WithdrawCapital;
  var Rollover;
  var Transfer;
  var MemberSince;
  var FandF;
  ReceivedAmountResponseData(
      {this.TotalReceived,
      this.WithdrawCapital,
      this.Rollover,
      this.Transfer,
      this.MemberSince,
      this.FandF});

  ReceivedAmountResponseData.fromJson(Map<String, dynamic> json) {
    TotalReceived = json['TotalReceived'];
    WithdrawCapital = json['WithdrawCapital'];
    MemberSince = json['MemberSince'];
    Rollover = json['Rollover'];
    Transfer = json['Transfer'];
    FandF = json['FandF'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalReceived'] = this.TotalReceived;
    data['WithdrawCapital'] = this.WithdrawCapital;
    data['Rollover'] = this.Rollover;
    data['Transfer'] = this.Transfer;
    data['MemberSince'] = this.MemberSince;
    data['FandF'] = this.FandF;
    return data;
  }
}
