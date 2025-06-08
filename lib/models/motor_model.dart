import 'package:hive/hive.dart';

part 'motor_model.g.dart';

@HiveType(typeId: 1)
class MotorModel extends HiveObject {
  @HiveField(0)
  int idMotor;

  @HiveField(1)
  String brandMotor;

  @HiveField(2)
  String modelMotor;

  @HiveField(3)
  String platNomor;

  @HiveField(4)
  String tahun;

  @HiveField(5)
  String pemilik;

  @HiveField(6)
  String? fotoPath;

  @HiveField(7)
  DateTime createdAt; // Tambahkan ini

  @HiveField(8)
  DateTime updatedAt; // Tambahkan ini

  MotorModel({
    required this.idMotor,
    required this.brandMotor,
    required this.modelMotor,
    required this.platNomor,
    required this.tahun,
    this.pemilik = "",
    this.fotoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}