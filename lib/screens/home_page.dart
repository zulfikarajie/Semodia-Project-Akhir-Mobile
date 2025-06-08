import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../utils/session_manager.dart';
import '../db/hive_db.dart';
import '../models/motor_model.dart';
import '../models/motorcycle.dart';
import '../utils/api_services.dart';
import 'login_page.dart';
import '../widgets/motor_card.dart';
import '../widgets/encyclopedia_card.dart';
import 'add_motor_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  List<Motorcycle> _encyclopediaResults = [];
  bool _loading = false;
  String? _error;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final uname = await SessionManager.getLoggedUser();
    setState(() {
      _username = uname;
    });
  }

  Future<void> _searchMotorcycles() async {
    final make = _makeController.text.trim();
    final model = _modelController.text.trim();
    if (make.isEmpty) {
      setState(() {
        _error = "Kolom 'Make' wajib diisi!";
        _encyclopediaResults = [];
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _encyclopediaResults = [];
    });
    try {
      final results = await ApiService().fetchMotorcycles(
        make: make,
        model: model,
      );
      setState(() {
        _encyclopediaResults = results;
        if (results.isEmpty) {
          _error = "Tidak ada data ditemukan untuk make/model tersebut.";
        }
      });
    } catch (e) {
      setState(() {
        _error = "Gagal mengambil data: ${e.toString()}";
      });
    }
    setState(() {
      _loading = false;
    });
  }

  void _goToDetail(Motorcycle motor) {
    Navigator.pushNamed(
      context,
      '/encyclopedia_detail',
      arguments: motor,
    );
  }

  void _logout() async {
    await SessionManager.clearSession();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final orange = Colors.orange;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SEMODIA',
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
      floatingActionButton: null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hi user di atas Ensiklopedia Motor
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                child: Text(
                  'Hi ${_username ?? ""}! Any thoughts today?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: orange,
                  ),
                ),
              ),
              // ENSIKLOPEDIA MOTOR SECTION
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: EdgeInsets.all(16),
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
                  border: Border.all(color: orange.withOpacity(0.15), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ensiklopedia Motor",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: orange,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _makeController,
                            decoration: InputDecoration(
                              labelText: "Make",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _modelController,
                            decoration: InputDecoration(
                              labelText: "Model",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _loading ? null : _searchMotorcycles,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orange,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("Find"),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (_loading)
                      Center(child: CircularProgressIndicator())
                    else if (_error != null)
                      Text(_error!, style: TextStyle(color: Colors.red))
                    else if (_encyclopediaResults.isEmpty)
                      Text("Masukkan make & model lalu tekan Find.")
                    else
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: _encyclopediaResults.length,
                          itemBuilder: (context, index) {
                            final m = _encyclopediaResults[index];
                            return EncyclopediaCard(
                              motorcycle: m,
                              onTap: () => _goToDetail(m),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              // MOTOR SAYA SECTION (Grid Horizontal)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "My Motorcycles",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: orange,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle, color: orange, size: 28),
                      tooltip: 'Tambah Motor',
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MotorFormPage()),
                        );
                        setState(() {}); // refresh setelah kembali dari tambah motor
                      },
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: HiveDB.motorsBox.listenable(),
                builder: (context, Box<MotorModel> box, _) {
                  final motors = box.values.toList()
                    ..sort((a, b) => b.idMotor.compareTo(a.idMotor));
                  final recentMotors = motors.take(4).toList();
                  if (recentMotors.isEmpty) {
                    return Center(child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text("Belum ada motor."),
                    ));
                  }
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
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
                    child: MotorGridRow(motors: recentMotors),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}