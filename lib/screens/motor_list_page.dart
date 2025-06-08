import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/motor_model.dart';
import '../widgets/motor_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../utils/session_manager.dart';

class MotorListPage extends StatefulWidget {
  const MotorListPage({Key? key}) : super(key: key);

  @override
  State<MotorListPage> createState() => _MotorListPageState();
}

class _MotorListPageState extends State<MotorListPage> {
  late Box<MotorModel> motorBox;
  String? _username;

  @override
  void initState() {
    super.initState();
    motorBox = Hive.box<MotorModel>('motors');
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final uname = await SessionManager.getLoggedUser();
    setState(() {
      _username = uname;
    });
  }

  void _logout() async {
    await SessionManager.clearSession();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orange;
    final cardColor = Theme.of(context).cardColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MOTOR LIST',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sapaan username di atas daftar motor
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: Text(
              'Hi ${_username ?? ""}! its all your motorcycles!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: orange,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: motorBox.listenable(),
              builder: (context, Box<MotorModel> box, _) {
                final motors = box.values.toList();
                if (motors.isEmpty) {
                  return Center(
                    child: Text(
                      "Belum ada motor.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: orange.withOpacity(0.1), width: 1),
                  ),
                  child: MotorGridRow(motors: motors),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}