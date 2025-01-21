import 'package:json_annotation/json_annotation.dart';

import '../../../models/base_model.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel extends BaseModel {
  final String title;
  final String message;

  NotificationModel({required this.title, required this.message})
      : super.fromJson({});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  @override
  Map<String, dynamic> toJson({bool isReference = false}) =>
      _$NotificationModelToJson(this);
}
