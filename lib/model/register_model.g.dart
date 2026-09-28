// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterModel _$RegisterModelFromJson(Map<String, dynamic> json) =>
    RegisterModel(
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$RegisterModelToJson(RegisterModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };

RegisterResponseModel _$RegisterResponseModelFromJson(
  Map<String, dynamic> json,
) => RegisterResponseModel(
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : RegisterDataSuccess.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegisterResponseModelToJson(
  RegisterResponseModel instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

RegisterDataSuccess _$RegisterDataSuccessFromJson(Map<String, dynamic> json) =>
    RegisterDataSuccess(token: json['token'] as String?);

Map<String, dynamic> _$RegisterDataSuccessToJson(
  RegisterDataSuccess instance,
) => <String, dynamic>{'token': instance.token};
