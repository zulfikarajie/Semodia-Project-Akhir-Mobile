import 'package:bcrypt/bcrypt.dart';

class BcryptHelper {
  static String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  static bool verifyPassword(String password, String hashed) {
    return BCrypt.checkpw(password, hashed);
  }
}
