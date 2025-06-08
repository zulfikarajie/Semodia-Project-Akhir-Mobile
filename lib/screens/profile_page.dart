import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../utils/session_manager.dart';
import '../main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? user;
  final _kesanPesanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final username = await SessionManager.getLoggedUser();
    if (username == null) return;
    final usersBox = Hive.box<UserModel>('users');
    final currentUser = usersBox.values.firstWhere(
      (u) => u.username == username,
      orElse: () => UserModel(username: username, email: '-', hashedPassword: ''),
    );
    setState(() {
      user = currentUser;
      _kesanPesanController.text = user?.kesanPesan ?? '';
    });
  }

  Future<void> _pickProfilePic() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null && user != null) {
      user!
        ..profilePicPath = picked.path
        ..save();
      setState(() {});
    }
  }

  Future<void> _saveKesanPesan() async {
    if (user != null) {
      user!
        ..kesanPesan = _kesanPesanController.text
        ..save();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kesan & Pesan disimpan!')),
      );
    }
  }

  Future<void> _testNotification() async {
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
      'Test Notifikasi',
      'Ini adalah notifikasi test dari menu profil.',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PROFILE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickProfilePic,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: (user!.profilePicPath != null && user!.profilePicPath!.isNotEmpty)
                    ? FileImage(File(user!.profilePicPath!))
                    : null,
                child: (user!.profilePicPath == null || user!.profilePicPath!.isEmpty)
                    ? Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(height: 16),
            Text(
              user!.username,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              user!.email,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),

            // Card Informasi Mahasiswa
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange, size: 36),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Nama: Zulfikar Ajie Pangarso',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'NIM: 123220035',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Card Kesan dan Pesan
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Colors.orange, size: 36),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Kesan & Pesan:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Matkulnya menarik tapi ga expect tugasnya bakal sebanyak ini, '
                            'jujur ke pressure karena belum bisa bagi waktu, '
                            'but overall sangat membantu proses belajar.',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Card Pengaturan Notifikasi
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.notifications_active_outlined, color: Colors.orange, size: 36),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _testNotification,
                        icon: Icon(Icons.notifications_active),
                        label: Text('Test Notifikasi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32),
            // (Optional) Kesan Pesan yang bisa diubah user
          ],
        ),
      ),
    );
  }
}