import 'package:workmanager/workmanager.dart';

const String taskName = "motor_reminder_task";

Future<void> scheduleReminder(int intervalHours) async {
  // Cancel task lama (jika ada)
  await Workmanager().cancelByUniqueName(taskName);

  // Daftarkan task periodik baru
  await Workmanager().registerPeriodicTask(
    "1",
    taskName,
    frequency: Duration(hours: intervalHours),
    initialDelay: Duration(minutes: 1), // opsional
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
  );
}