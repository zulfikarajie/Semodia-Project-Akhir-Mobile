import 'package:hive/hive.dart';

part 'service_record_model.g.dart';

@HiveType(typeId: 2)
class ServiceRecordModel extends HiveObject {
  @HiveField(0)
  int idRecord; // unique id, bisa pakai timestamp atau auto increment

  @HiveField(1)
  int idMotor; // relasi ke motor

  @HiveField(2)
  DateTime tanggalService;

  @HiveField(3)
  int kmService;

  @HiveField(4)
  String jenisService; // Status: Major/Minor

  @HiveField(5)
  String keterangan;

  @HiveField(6)
  int biaya;

  @HiveField(7)
  List<String> daftarSparepart;

  @HiveField(8)
  String? zonaWaktu; // Tambahan: zona waktu (WIB, WITA, WIT, London)

  @HiveField(9)
  String? currency; // Tambahan: currency (IDR, USD, JPY, EUR)

  ServiceRecordModel({
    required this.idRecord,
    required this.idMotor,
    required this.tanggalService,
    required this.kmService,
    required this.jenisService,
    this.keterangan = "",
    required this.biaya,
    this.daftarSparepart = const [],
    this.zonaWaktu,
    this.currency,
  });
}