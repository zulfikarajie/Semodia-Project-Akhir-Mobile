import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _userKey = 'user';
  static const String _loginTimeKey = 'loginTime';
  static const int sessionDuration = 600; // 10 menit

  static Future<void> saveSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, username);
    await prefs.setInt(_loginTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_loginTimeKey);
  }

  static Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTime = prefs.getInt(_loginTimeKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - loginTime) < (sessionDuration * 1000);
  }

  static Future<String?> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }
}
