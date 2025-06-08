import 'package:flutter/material.dart';
import 'reminder_helper.dart';

class ReminderSettingsPage extends StatefulWidget {
  @override
  State<ReminderSettingsPage> createState() => _ReminderSettingsPageState();
}

class _ReminderSettingsPageState extends State<ReminderSettingsPage> {
  int _interval = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Notifikasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Setel interval notifikasi pengingat cek motor (jam):',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _interval.toDouble(),
                    min: 1,
                    max: 24,
                    divisions: 23,
                    label: '$_interval jam',
                    onChanged: (val) {
                      setState(() {
                        _interval = val.toInt();
                      });
                    },
                  ),
                ),
                SizedBox(width: 12),
                Text('$_interval jam'),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await scheduleReminder(_interval);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notifikasi diatur setiap $_interval jam!')),
                );
              },
              child: Text('Aktifkan Notifikasi'),
            ),
            SizedBox(height: 24),
            Text(
              'Notifikasi akan tetap berjalan walaupun aplikasi ditutup (khusus Android).',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}