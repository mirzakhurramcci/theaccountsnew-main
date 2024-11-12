class PaymentRolloverHistoryResponse {
  PaymentRolloverHistoryResponse({
    required this.data,
    required this.message,
    required this.errorList,
  });

  late List<PaymentRolloverHistoryResponseData>? data;
  late String message;
  late List<String> errorList;
  factory PaymentRolloverHistoryResponse.fromJson(Map<String, dynamic> json) =>
      PaymentRolloverHistoryResponse(
        data: json["Data"] == null
            ? null
            : List<PaymentRolloverHistoryResponseData>.from(json["Data"]
                .map((x) => PaymentRolloverHistoryResponseData.fromJson(x))),
        message: json["Message"] == null ? "" : json["Message"],
        errorList: List<String>.from(json["ErrorList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        //"Data": data.toJson(),
        "Message": message,
        "ErrorList": List<dynamic>.from(errorList.map((x) => x)),
      };
}

class PaymentRolloverHistoryResponseData {
  num? ID;
  String? Date;
  String? DateStr;
  String? ClosingMonth;
  num? Amount;
  num? Rollover;
  num? Transfer;
  String? Status;
  String? Type;

  PaymentRolloverHistoryResponseData(
      {this.ID,
      this.Date,
      this.DateStr,
      this.ClosingMonth,
      this.Rollover,
      this.Transfer,
      this.Status,
      this.Amount,
      this.Type});

  PaymentRolloverHistoryResponseData.fromJson(Map<String, dynamic> json) {
    ID = json['ID'];
    Date = json['Date'];
    DateStr = json['DateStr'];
    ClosingMonth = json['ClosingMonth'];
    Amount = json['Amount'];
    Type = json["Type"];
    Status = json['Status'];
    Rollover = json['Rollover'];
    Transfer = json["Transfer"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.ID;
    data['Date'] = this.Date;
    data['DateStr'] = this.DateStr;
    data['ClosingMonth'] = this.ClosingMonth;
    data['Amount'] = this.Amount;
    data["Type"] = this.Type;
    data['Rollover'] = this.Rollover;
    data['Transfer'] = this.Transfer;
    data["Status"] = this.Status;
    return data;
  }
}
