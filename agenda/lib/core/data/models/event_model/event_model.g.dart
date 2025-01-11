// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      uuid: json['uuid'] as String,
      participantsEmails: (json['participantsEmails'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      notes:
          (json['notes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isUserEvent: json['isUserEvent'] as bool? ?? false,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'uuid': instance.uuid,
      'participantsEmails': instance.participantsEmails,
      'notes': instance.notes,
      'attachments': instance.attachments,
      'isUserEvent': instance.isUserEvent,
    };
