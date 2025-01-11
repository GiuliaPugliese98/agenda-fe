import 'package:agenda/core/data/models/event_model_to_add/event_model_to_add.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel extends EventModelToAdd {
  final List<String>? participantsEmails;
  final List<String>? notes;
  final List<String>? attachments;
  final bool isUserEvent;

  EventModel({
    required super.title,
    required super.description,
    required super.startDate,
    required super.endDate,
    required this.participantsEmails,
    required this.notes,
    required this.attachments,
    this.isUserEvent = false
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => _$EventModelFromJson(json);

  @override
  Map<String, dynamic> toJson({bool isReference = false}) => _$EventModelToJson(this);
}