import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/data/model/story.dart';

part 'detail_story_model.g.dart';

@JsonSerializable()
class DetailStoryModel {
  bool? error;
  String? message;
  Story? story;

  DetailStoryModel({
    this.error,
    this.message,
    this.story,
  });

  factory DetailStoryModel.fromJson(Map<String, dynamic> json) =>
      _$DetailStoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailStoryModelToJson(this);
}
