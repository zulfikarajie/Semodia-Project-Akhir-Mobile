import 'package:flutter/material.dart';
import 'db/hive_db.dart';
import 'screens/login_page.dart';
import 'utils/session_manager.dart';
import 'screens/encyclopedia_detail_page.dart';
import 'utils/local_time_helper.dart';
import 'widgets/bottom_navbar.dart';
import 'reminder_settings_page.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const String taskName = "motor_reminder_task";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'reminder_channel',
      'Motor Reminder',
      channelDescription: 'Notifikasi pengingat cek motor',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Cek Motor!',
      'Jangan lupa cek motor sebelum digunakan.',
      platformChannelSpecifics,
    );
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDB.init();

  // Inisialisasi notifikasi
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Inisialisasi Workmanager
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  // Jadwalkan task periodik (misal setiap 4 jam)
  await Workmanager().registerPeriodicTask(
    "1",
    taskName,
    frequency: Duration(hours: 4),
    initialDelay: Duration(minutes: 1), // opsional
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _setThemeByLocalTime();
  }

  Future<void> _setThemeByLocalTime() async {
    try {
      final localTime = await getLocalDateTime();
      int hour = localTime.hour;
      setState(() {
        _themeMode = (hour >= 6 && hour < 18)
            ? ThemeMode.light
            : ThemeMode.dark;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _themeMode = ThemeMode.system;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Container(color: Colors.white);
    return MaterialApp(
      title: 'Service Motor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(primary: Colors.orange),
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.orange),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.orange,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(primary: Colors.orange),
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
        appBarTheme: AppBarTheme(backgroundColor: Colors.orange),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.orange[800],
        ),
      ),
      themeMode: _themeMode,
      home: FutureBuilder<bool>(
        future: SessionManager.isSessionValid(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox();
          }
          if (snapshot.data ?? false) {
            return BottomNavbar();
          } else {
            return LoginPage();
          }
        },
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => BottomNavbar(),
        '/encyclopedia_detail': (context) => EncyclopediaDetailPage(),
        '/reminder_settings': (context) => ReminderSettingsPage(),
      },
    );
  }
}