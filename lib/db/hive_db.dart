import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/motor_model.dart';
import '../models/service_record_model.dart';

class HiveDB {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(MotorModelAdapter());
    Hive.registerAdapter(ServiceRecordModelAdapter());
    await Hive.openBox<UserModel>('users');
    await Hive.openBox<MotorModel>('motors');
    await Hive.openBox<ServiceRecordModel>('service_records');
  }

  static Box<UserModel> get usersBox => Hive.box<UserModel>('users');
  static Box<MotorModel> get motorsBox => Hive.box<MotorModel>('motors');
  static Box<ServiceRecordModel> get serviceRecordsBox => Hive.box<ServiceRecordModel>('service_records');
}
