import 'package:flutter/material.dart';
import '../models/motorcycle.dart';

class EncyclopediaCard extends StatelessWidget {
  final Motorcycle motorcycle;
  final VoidCallback? onTap;

  const EncyclopediaCard({
    Key? key,
    required this.motorcycle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text("${motorcycle.make} ${motorcycle.model}"),
        subtitle: Text("Tahun: ${motorcycle.year} | Type: ${motorcycle.type}"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
