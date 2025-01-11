import 'package:agenda/core/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_model_to_add.g.dart';

@JsonSerializable()
class EventModelToAdd extends BaseModel{
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  EventModelToAdd({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  }) : super.fromJson({});

  factory EventModelToAdd.fromJson(Map<String, dynamic> json) => _$EventModelToAddFromJson(json);

  @override
  Map<String, dynamic> toJson({bool isReference = false}) => _$EventModelToAddToJson(this);
}