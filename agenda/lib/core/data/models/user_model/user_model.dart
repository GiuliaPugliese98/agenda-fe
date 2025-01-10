import 'package:json_annotation/json_annotation.dart';
import '../../../models/base_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends BaseModel {
  final String name;
  final String email;
  final String password;

  UserModel({
    required this.name,
    required this.email,
    required this.password
  }) : super.fromJson({});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  @override
  Map<String, dynamic> toJson({bool isReference = false}) => _$UserModelToJson(this);
}