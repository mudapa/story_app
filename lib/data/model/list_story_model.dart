import 'package:json_annotation/json_annotation.dart';

import 'story.dart';

part 'list_story_model.g.dart';

@JsonSerializable()
class ListStoryModel {
  bool? error;
  String? message;
  List<Story>? listStory;

  ListStoryModel({
    this.error,
    this.message,
    this.listStory,
  });

  factory ListStoryModel.fromJson(Map<String, dynamic> json) =>
      _$ListStoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListStoryModelToJson(this);
}
