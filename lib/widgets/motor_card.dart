import 'dart:io';
import 'package:flutter/material.dart';
import '../models/motor_model.dart';
import '../screens/motor_detail_page.dart';

class MotorGridRow extends StatelessWidget {
  final List<MotorModel> motors;
  final void Function(MotorModel)? onTap;

  const MotorGridRow({
    Key? key,
    required this.motors,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black);
    final subtitleColor = theme.textTheme.bodySmall?.color ?? (isDark ? Colors.grey[300] : Colors.grey[600]);
    final iconColor = isDark ? Colors.grey[300] : Colors.grey[700];
    final emptyIconColor = isDark ? Colors.grey[600] : Colors.grey[400];
    final emptyTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    if (motors.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.motorcycle, size: 48, color: emptyIconColor),
              SizedBox(height: 12),
              Text(
                "Belum ada motor yang terdaftar",
                style: TextStyle(fontSize: 16, color: emptyTextColor),
              ),
            ],
          ),
        ),
      );
    }

    final sortedMotors = List<MotorModel>.from(motors)
      ..sort((a, b) => (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt));
    final recentMotors = sortedMotors.toList();

    return SizedBox(
      height: 600,
      child: ListView.builder(
        itemCount: recentMotors.length,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemBuilder: (context, idx) {
          final motor = recentMotors[idx];
          return GestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap!(motor);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MotorDetailPage(motor: motor, index: idx),
                  ),
                );
              }
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black12,
                    )
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: motor.fotoPath != null
                          ? Image.file(
                              File(motor.fotoPath!),
                              width: 90,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 90,
                              height: 70,
                              color: isDark ? Colors.grey[800] : Colors.grey[300],
                              child: Icon(Icons.motorcycle, size: 36, color: iconColor),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            motor.modelMotor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            motor.platNomor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}