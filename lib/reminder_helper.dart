import 'package:workmanager/workmanager.dart';

const String taskName = "motor_reminder_task";

Future<void> scheduleReminder(int intervalMinutes) async {
  // Cancel task lama (jika ada)
  await Workmanager().cancelByUniqueName(taskName);

  // Daftarkan task periodik baru
  await Workmanager().registerPeriodicTask(
    "1",
    taskName,
    frequency: Duration(minutes: intervalMinutes),
    initialDelay: Duration(minutes: 1),
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
  );
}

Future<void> activateTestNotif() async {
  await scheduleReminder(1); // 1 menit sekali
}

Future<void> activateNormalNotif() async {
  await scheduleReminder(60 * 24); // 1 hari sekali
}