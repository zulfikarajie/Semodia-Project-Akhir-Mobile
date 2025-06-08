import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/google_place.dart';

class GooglePlacesApi {
  static const String _apiKey = 'AIzaSyBD7khB3Zvf5LaIh0iWMc_Xn-oXVEo1kCM';

  /// Search places by text query using Google Places Text Search API
    static Future<List<GooglePlace>> searchByText({
    required String textQuery,
    Map<String, double>? locationBias, // Tambahkan ini
    String fieldMask = 'places.displayName,places.formattedAddress,places.location',
    int maxResults = 10,
  }) async {
    final url = 'https://places.googleapis.com/v1/places:searchText?key=$_apiKey';
  
    final body = <String, dynamic>{
      "textQuery": textQuery,
      "maxResultCount": maxResults,
    };
    if (locationBias != null) {
      body["locationBias"] = {
        "circle": {
          "center": {
            "latitude": locationBias["latitude"],
            "longitude": locationBias["longitude"]
          },
          "radius": 3000 // meter, bisa diubah sesuai kebutuhan
        }
      };
    }
  
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': _apiKey,
        'X-Goog-FieldMask': fieldMask,
      },
      body: jsonEncode(body),
    );
  
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final places = (data['places'] as List?) ?? [];
      return places.map((p) => GooglePlace.fromJson(p)).toList();
    } else {
      throw Exception('Failed to fetch places: ${response.body}');
    }
  }

  /// Search nearby places using Google Places Nearby Search API v1
  static Future<List<GooglePlace>> searchNearby({
    required double lat,
    required double lng,
    int radius = 2000,
    int maxResults = 10,
    String fieldMask = 'places.displayName,places.formattedAddress,places.location',
  }) async {
    final url = 'https://places.googleapis.com/v1/places:searchNearby?key=$_apiKey';

    final body = jsonEncode({
      "locationRestriction": {
        "circle": {
          "center": {"latitude": lat, "longitude": lng},
          "radius": radius
        }
      },
      "maxResultCount": maxResults,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': _apiKey,
        'X-Goog-FieldMask': fieldMask,
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final places = (data['places'] as List?) ?? [];
      return places.map((p) => GooglePlace.fromJson(p)).toList();
    } else {
      throw Exception('Failed to fetch places: ${response.body}');
    }
  }
}