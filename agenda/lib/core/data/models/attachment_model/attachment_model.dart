import 'package:json_annotation/json_annotation.dart';

part 'attachment_model.g.dart';

@JsonSerializable()
class AttachmentModel {
  final int id;
  final String fileName;
  final String fileType;
  final String fileUrl;

    AttachmentModel({
      required this.id,
      required this.fileName,
      required this.fileType,
      required this.fileUrl
    });

    factory AttachmentModel.fromJson(Map<String, dynamic> json) => _$AttachmentModelFromJson(json);

    @override
    Map<String, dynamic> toJson({bool isReference = false}) => _$AttachmentModelToJson(this);
  }