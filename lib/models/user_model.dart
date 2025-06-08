import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String email;

  @HiveField(2)
  String hashedPassword;

  @HiveField(3)
  String? profilePicPath; // Tambahkan ini

  @HiveField(4)
  String? kesanPesan; // (opsional, jika ingin simpan di user)

  UserModel({
    required this.username,
    required this.email,
    required this.hashedPassword,
    this.profilePicPath,
    this.kesanPesan,
  });
}