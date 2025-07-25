import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/wallpaper.dart';

class WallpaperApiService {

  List<Photo> photos = [];
  int page = 0;
  int perPage = 15;
  String currentCategory = 'nature';

  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BASE_URL']!,
    headers: {'Authorization': dotenv.env['API_KEY']},
  ));

  Future<List<Photo>> fetchWallpapers({String? category, bool reset = false}) async {
    if (reset) {
      page = 1;
      photos.clear();
      currentCategory = category ?? currentCategory;
    } else {
      page++;
      if (category != null && category != currentCategory) {
        // If category changed, reset
        page = 1;
        photos.clear();
        currentCategory = category;
      }
    }

    final response = await dio.get('search', queryParameters: {
      'query': currentCategory,
      'page': page,
      'per_page': perPage
    });

    if (response.statusCode == 200) {
      final data = response.data;
      photos.addAll((data['photos'] as List)
          .map((photoJson) => Photo.fromJson(photoJson))
          .toList());
      return List<Photo>.from(photos);
    }
    if(response.statusCode == 429){
      throw Exception("Too many requests");
    }
    else {
      throw Exception('Failed to fetch wallpapers: ${response.statusCode}');
    }
  }
}
