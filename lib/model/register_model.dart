import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'register_model.g.dart';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

// CLASS UNTUK REQUEST (Data yang dikirim ke server)
@JsonSerializable()
class RegisterModel {
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "password")
  String? password;

  RegisterModel({this.name, this.email, this.password});

  factory RegisterModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterModelToJson(this);
}

// CLASS UNTUK MENANGKAP RESPON (menangkap data yang diterima dari server)
@JsonSerializable()
class RegisterResponseModel {
  @JsonKey(name: "message")
  String? message;

  // Karena backend mengirim data sukses di dalam key "data"
  @JsonKey(name: "data")
  RegisterDataSuccess? data;

  RegisterResponseModel({this.message, this.data});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResponseModelToJson(this);
}

// Tambahkan class baru ini di bawahnya untuk menampung token dan user info
@JsonSerializable()
class RegisterDataSuccess {
  @JsonKey(name: "token")
  String? token;

  RegisterDataSuccess({this.token});

  factory RegisterDataSuccess.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataSuccessFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterDataSuccessToJson(this);
}
