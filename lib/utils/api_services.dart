import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/motorcycle.dart';

class ApiService {
  static const String baseUrl = 'https://api.api-ninjas.com/v1/motorcycles';
  static const String apiKey = 'QUMeLqzUACxuRhdoCjrH2w==7QOBaIxeacvu2z6w';

  Future<List<Motorcycle>> fetchMotorcycles({
    String? make,
    String? model,
    String? year,
  }) async {
    final Map<String, String> params = {};
    if (make != null && make.isNotEmpty) params['make'] = make;
    if (model != null && model.isNotEmpty) params['model'] = model;
    if (year != null && year.isNotEmpty) params['year'] = year;
    final uri = Uri.parse(baseUrl).replace(queryParameters: params);

    final response = await http.get(uri, headers: {'X-Api-Key': apiKey});
    // ignore: avoid_print
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Motorcycle.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load motorcycles');
    }
  }
}
