// To parse this JSON data, do
//
//     final registerRespon = registerResponFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';

part 'register_respon.g.dart';

RegisterRespon registerResponFromJson(String str) =>
    RegisterRespon.fromJson(json.decode(str));

String registerResponToJson(RegisterRespon data) => json.encode(data.toJson());

@JsonSerializable()
class RegisterRespon {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final Data? data;

  RegisterRespon({this.message, this.data});

  factory RegisterRespon.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "token")
  final String? token;
  @JsonKey(name: "user")
  final User? user;

  Data({this.token, this.user});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @JsonKey(name: "id")
  final int? id;

  User({this.name, this.email, this.updatedAt, this.createdAt, this.id});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
