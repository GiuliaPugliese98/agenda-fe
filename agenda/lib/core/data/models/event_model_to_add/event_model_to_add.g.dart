// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model_to_add.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModelToAdd _$EventModelToAddFromJson(Map<String, dynamic> json) =>
    EventModelToAdd(
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$EventModelToAddToJson(EventModelToAdd instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };
