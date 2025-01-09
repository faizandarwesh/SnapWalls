import 'package:dio/dio.dart';
import 'package:snap_walls/utils/app_constants.dart';
import '../model/wallpaper.dart';

class WallpaperApiService {

  List<Photo> photos = [];
  int page = 0;
  int perPage = 15;

  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    headers: {'Authorization': AppConstants.apiKey},
  ));

   Future<List<Photo>> fetchWallpapers() async {

     page++;

    final response = await dio.get('search', queryParameters: {
      'query': 'nature',
      'page': page,
      'per_page': perPage
    });

    if (response.statusCode == 200) {
      // Parse the response and map it to the Photo model
      final data = response.data;
      photos.addAll((data['photos'] as List)
          .map((photoJson) => Photo.fromJson(photoJson))
          .toList());

      return photos;
    }
    if(response.statusCode == 429){
      throw Exception("Too many requests");
    }
    else {
      throw Exception('Failed to fetch wallpapers: ${response.statusCode}');
    }
  }
}
