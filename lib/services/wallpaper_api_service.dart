import 'package:dio/dio.dart';
import 'package:snap_walls/utils/app_constants.dart';
import '../model/wallpaper.dart';

class WallpaperApiService {

  List<Photo> photos = [];

  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    headers: {'Authorization': AppConstants.apiKey},
  ));

   Future<List<Photo>> fetchWallpapers({int page = 1, int perPage = 15}) async {
    final response = await dio.get('search', queryParameters: {
      'query': 'nature',
      'page': page,
      'per_page': perPage
    });

    if (response.statusCode == 200) {
      // Parse the response and map it to the Photo model
      final data = response.data;
      photos = (data['photos'] as List)
          .map((photoJson) => Photo.fromJson(photoJson))
          .toList();

      return photos;
    }  else {
      throw Exception('Failed to fetch wallpapers: ${response.statusCode}');
    }
  }
}
