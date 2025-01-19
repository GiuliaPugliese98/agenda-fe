// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentModel _$AttachmentModelFromJson(Map<String, dynamic> json) =>
    AttachmentModel(
      id: (json['id'] as num).toInt(),
      fileName: json['fileName'] as String,
      fileType: json['fileType'] as String,
      fileUrl: json['fileUrl'] as String,
    );

Map<String, dynamic> _$AttachmentModelToJson(AttachmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'fileType': instance.fileType,
      'fileUrl': instance.fileUrl,
    };
