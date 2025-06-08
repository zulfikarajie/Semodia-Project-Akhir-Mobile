import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String timezonedbApiKey = 'WSTP2YT51TE3';
const String baseUrl = 'https://api.timezonedb.com/v2.1/get-time-zone';

Future<DateTime> getLocalDateTime() async {
  // 1. Ambil lokasi user
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return DateTime.now();
  }
  Position pos = await Geolocator.getCurrentPosition();

  // 2. Hit API TimeZoneDB
  final url = Uri.parse(
    '$baseUrl?key=$timezonedbApiKey&format=json&by=position&lat=${pos.latitude}&lng=${pos.longitude}',
  );
  final response = await http.get(url);
  if (response.statusCode != 200) return DateTime.now();

  final data = jsonDecode(response.body);
  // Cek jika response OK
  if (data['status'] != 'OK') return DateTime.now();

  // Ambil waktu lokal user dari field 'formatted'
  // Contoh: "formatted": "2024-06-08 12:34:56"
  final formatted = data['formatted'];
  if (formatted is String && formatted.length >= 19) {
    // format yyyy-MM-dd HH:mm:ss
    return DateTime.parse(formatted);
  }

  // fallback: pakai offset manual
  final gmtOffset = data['gmtOffset'] ?? 0; // detik
  final utcNow = DateTime.now().toUtc();
  return utcNow.add(Duration(seconds: gmtOffset));
}
