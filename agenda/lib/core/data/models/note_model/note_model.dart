import 'package:json_annotation/json_annotation.dart';
import '../../../models/base_model.dart';

part 'note_model.g.dart';

@JsonSerializable()
class NoteModel extends BaseModel {
  final int id;
  final String content;

  NoteModel({
    required this.id,
    required this.content,
  }) : super.fromJson({});

  factory NoteModel.fromJson(Map<String, dynamic> json) => _$NoteModelFromJson(json);

  @override
  Map<String, dynamic> toJson({bool isReference = false}) => _$NoteModelToJson(this);
}
