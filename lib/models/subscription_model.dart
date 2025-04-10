import 'dart:convert';

class SubscriptionResponse {
  final String status;
  final List<SubscriptionData> data;
  final int subbscriptionId;
  //final int subscriptionId; // Added subscriptionId field

  SubscriptionResponse({
    required this.status,
    required this.data,
    required this.subbscriptionId,
    /*required this.subscriptionId*/
  });

  factory SubscriptionResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    print('✅ JJJJJJ ID: ${json["data"][0]["SubscriptionId"]}');

    var list = json['data'] as List? ?? [];
    List<SubscriptionData> dataList =
        list.map((i) => SubscriptionData.fromJson(i)).toList();

    return SubscriptionResponse(
      subbscriptionId: json["data"][0]["SubscriptionId"],
      status: json['status'], // Default value if missing
      data: dataList,
      //subscriptionId: json['SubscriptionId'],
    );
  }
}

class SubscriptionData {
  final String eMagazineType;
  final String name;
  final String whatsappNo;
  final String mobileNo;
  final String emailId;
  final int issueId;
  final int postTypeId;
  final double amount;
  final double postTypeAmount;
  final double totalAmount;
  final String state;
  final String city;
  final String pinCode;
  final String landMark;
  final String address;
  final int addedBy;

  SubscriptionData({
    required this.eMagazineType,
    required this.name,
    required this.whatsappNo,
    required this.mobileNo,
    required this.emailId,
    required this.issueId,
    required this.postTypeId,
    required this.amount,
    required this.postTypeAmount,
    required this.totalAmount,
    required this.state,
    required this.city,
    required this.pinCode,
    required this.landMark,
    required this.address,
    required this.addedBy,
  });

  // Convert object to JSON for sending to API
  Map<String, dynamic> toJson() {
    return {
      'EMagazineType': eMagazineType,
      'Name': name,
      'WhatsappNo': whatsappNo,
      'MobileNo': mobileNo,
      'EmailId': emailId,
      'IssueId': issueId,
      'PostTypeId': postTypeId,
      'Amount': amount,
      'PostTypeAmount': postTypeAmount,
      'TotalAmount': totalAmount,
      'State': state,
      'City': city,
      'PinCode': pinCode,
      'LandMark': landMark,
      'Address': address,
      'AddedBy': addedBy,
    };
  }

  // Convert JSON to object (handles missing values safely)
  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      eMagazineType: json['EMagazineType'] ?? '',
      name: json['Name'] ?? '',
      whatsappNo: json['WhatsappNo'] ?? '',
      mobileNo: json['MobileNo'] ?? '',
      emailId: json['EmailId'] ?? '',
      issueId: json['IssueId'] ?? 0,
      postTypeId: json['PostTypeId'] ?? 0,
      amount: (json['Amount'] ?? 0).toDouble(),
      postTypeAmount: (json['PostTypeAmount'] ?? 0).toDouble(),
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
      state: json['State'] ?? '',
      city: json['City'] ?? '',
      pinCode: json['PinCode'] ?? '',
      landMark: json['LandMark'] ?? '',
      address: json['Address'] ?? '',
      addedBy: json['AddedBy'] ?? 0,
    );
  }
}

// import 'dart:convert';

// class SubscriptionResponse {
//   final String status;
//   final List<SubscriptionData> data;

//   SubscriptionResponse({required this.status, required this.data});

//   factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
//     var list = json['data'] as List;
//     List<SubscriptionData> dataList =
//         list.map((i) => SubscriptionData.fromJson(i)).toList();
//     return SubscriptionResponse(status: json['status'], data: dataList);
//   }
// }
// class SubscriptionData {
//   final String eMagazineType;
//   final String name;
//   final String whatsappNo;
//   final String mobileNo;
//   final String emailId;
//   final int issueId;
//   final int postTypeId;
//   final double amount;
//   final double postTypeAmount;
//   final double totalAmount;
//   final String state;
//   final String city;
//   final String pinCode;
//   final String landMark;
//   final String address;
//   final int addedBy;

//   SubscriptionData({
//     required this.eMagazineType,
//     required this.name,
//     required this.whatsappNo,
//     required this.mobileNo,
//     required this.emailId,
//     required this.issueId,
//     required this.postTypeId,
//     required this.amount,
//     required this.postTypeAmount,
//     required this.totalAmount,
//     required this.state,
//     required this.city,
//     required this.pinCode,
//     required this.landMark,
//     required this.address,
//     required this.addedBy,
//   });

//   // Convert object to JSON for sending to API
//   Map<String, dynamic> toJson() {
//     return {
//       'EMagazineType': eMagazineType,
//       'Name': name,
//       'WhatsappNo': whatsappNo,
//       'MobileNo': mobileNo,
//       'EmailId': emailId,
//       'IssueId': issueId,
//       'PostTypeId': postTypeId,
//       'Amount': amount,
//       'PostTypeAmount': postTypeAmount,
//       'TotalAmount': totalAmount,
//       'State': state,
//       'City': city,
//       'PinCode': pinCode,
//       'LandMark': landMark,
//       'Address': address,
//       'AddedBy': addedBy,
//     };
//   }

//   // Convert JSON to object (if needed)
//   factory SubscriptionData.fromJson(Map<String, dynamic> json) {
//     return SubscriptionData(
//       eMagazineType: json['EMagazineType'],
//       name: json['Name'],
//       whatsappNo: json['WhatsappNo'],
//       mobileNo: json['MobileNo'],
//       emailId: json['EmailId'],
//       issueId: json['IssueId'],
//       postTypeId: json['PostTypeId'],
//       amount: json['Amount'].toDouble(),
//       postTypeAmount: json['PostTypeAmount'].toDouble(),
//       totalAmount: json['TotalAmount'].toDouble(),
//       state: json['State'],
//       city: json['City'],
//       pinCode: json['PinCode'],
//       landMark: json['LandMark'],
//       address: json['Address'],
//       addedBy: json['AddedBy'],
//     );
//   }
// }
