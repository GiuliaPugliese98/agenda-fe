// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_credentials_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCredentialsModel _$UserCredentialsModelFromJson(
        Map<String, dynamic> json) =>
    UserCredentialsModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserCredentialsModelToJson(
        UserCredentialsModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };
