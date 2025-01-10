abstract class BaseModel{

  BaseModel.fromJson(Map<String, Object?> json);
  Map<String, Object?> toJson({bool isReference});
}