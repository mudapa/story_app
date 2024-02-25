class StoryModel {
  bool? error;
  String? message;
  List<Story>? listStory;

  StoryModel({
    this.error,
    this.message,
    this.listStory,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
        error: json["error"],
        message: json["message"],
        listStory: json["listStory"] == null
            ? []
            : List<Story>.from(
                json["listStory"]!.map((x) => Story.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "listStory": listStory == null
            ? []
            : List<dynamic>.from(listStory!.map((x) => x.toJson())),
      };
}

class DetailStory {
  bool? error;
  String? message;
  Story? story;

  DetailStory({
    this.error,
    this.message,
    this.story,
  });

  factory DetailStory.fromJson(Map<String, dynamic> json) => DetailStory(
        error: json["error"],
        message: json["message"],
        story: json["story"] == null ? null : Story.fromJson(json["story"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "story": story?.toJson(),
      };
}

class Story {
  String? id;
  String? name;
  String? description;
  String? photoUrl;
  DateTime? createdAt;
  double? lat;
  double? lon;

  Story({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "createdAt": createdAt?.toIso8601String(),
        "lat": lat,
        "lon": lon,
      };
}

class UploadResponse {
  bool? error;
  String? message;

  UploadResponse({
    this.error,
    this.message,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> map) {
    return UploadResponse(
      error: map['error'],
      message: map['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
    };
  }
}
