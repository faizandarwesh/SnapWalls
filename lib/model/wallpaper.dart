// To parse this JSON data, do
//
//     final wallpaper = wallpaperFromJson(jsonString);

import 'dart:convert';

Wallpaper wallpaperFromJson(String str) => Wallpaper.fromJson(json.decode(str));

String wallpaperToJson(Wallpaper data) => json.encode(data.toJson());

class Wallpaper {
  int page;
  int perPage;
  List<Photo> photos;
  int totalResults;
  String nextPage;
  String prevPage;

  Wallpaper({
    required this.page,
    required this.perPage,
    required this.photos,
    required this.totalResults,
    required this.nextPage,
    required this.prevPage,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) => Wallpaper(
    page: json["page"],
    perPage: json["per_page"],
    photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
    totalResults: json["total_results"],
    nextPage: json["next_page"],
    prevPage: json["prev_page"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "per_page": perPage,
    "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
    "total_results": totalResults,
    "next_page": nextPage,
    "prev_page": prevPage,
  };
}

class Photo {
  int id;
  String url;

  Photo({
    required this.id,
    required this.url,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    id: json["id"],
    url: json["src"]['original'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
  };
}
