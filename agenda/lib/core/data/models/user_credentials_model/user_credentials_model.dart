import 'package:json_annotation/json_annotation.dart';

import '../../../models/base_model.dart';

part 'user_credentials_model.g.dart';

@JsonSerializable()
class UserCredentialsModel extends BaseModel {
  final String email;
  final String password;

  UserCredentialsModel({
    required this.email,
    required this.password,
  }) : super.fromJson({});

  factory UserCredentialsModel.fromJson(Map<String, dynamic> json) => _$UserCredentialsModelFromJson(json);

  @override
  Map<String, dynamic> toJson({bool isReference = false}) => _$UserCredentialsModelToJson(this);
}