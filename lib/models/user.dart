import 'dart:io';

class User {
  final String? userId;
  final String? name;
  final String? state;
  final String? stateName;
  final String? phoneNumber;
  final String? address;
  final String? email;
  final DateTime? dob;
  final String? gender;
  late final String? imgPath;
  final String? whatsappNumber;

  User({
    this.userId,
    this.name,
    this.state,
    this.stateName,
    this.phoneNumber,
    this.address,
    this.email,
    this.dob,
    this.gender,
    this.imgPath,
    this.whatsappNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "state": state,
      "stateName": stateName,
      "phoneNumber": phoneNumber,
      "address": address,
      "email": email,
      "gender": gender,
      // "imgPath": imgPath,
      "dob": dob?.toIso8601String(), // Convert DateTime to String
    };
  }

  // Create User object from JSON (decoded Map)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      state: json["state"],
      stateName: json["stateName"],
      phoneNumber: json["phoneNumber"],
      address: json["address"],
      email: json["email"],
      gender: json["gender"],
      // imgPath: json["imgPath"],
      dob: DateTime.parse(json["dob"]), // Convert String back to DateTime
    );
  }
}
