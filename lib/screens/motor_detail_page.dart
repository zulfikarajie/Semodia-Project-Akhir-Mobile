import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/motor_model.dart';
import '../db/hive_db.dart';
import 'service_record_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MotorDetailPage extends StatefulWidget {
  final MotorModel motor;
  final int index;
  const MotorDetailPage({required this.motor, required this.index});

  @override
  State<MotorDetailPage> createState() => _MotorDetailPageState();
}

class _MotorDetailPageState extends State<MotorDetailPage> {
  late TextEditingController brandController;
  late TextEditingController modelController;
  late TextEditingController platController;
  late TextEditingController tahunController;
  late TextEditingController pemilikController;
  bool isEditing = false;

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    brandController = TextEditingController(text: widget.motor.brandMotor);
    modelController = TextEditingController(text: widget.motor.modelMotor);
    platController = TextEditingController(text: widget.motor.platNomor);
    tahunController = TextEditingController(text: widget.motor.tahun);
    pemilikController = TextEditingController(text: widget.motor.pemilik);

    if (widget.motor.fotoPath != null && File(widget.motor.fotoPath!).existsSync()) {
      _imageFile = File(widget.motor.fotoPath!);
    }
  }

  @override
  void dispose() {
    brandController.dispose();
    modelController.dispose();
    platController.dispose();
    tahunController.dispose();
    pemilikController.dispose();
    super.dispose();
  }

  void _saveEdit() {
    setState(() {
      widget.motor.brandMotor = brandController.text;
      widget.motor.modelMotor = modelController.text;
      widget.motor.platNomor = platController.text;
      widget.motor.tahun = tahunController.text;
      widget.motor.pemilik = pemilikController.text;
      if (_imageFile != null) {
        widget.motor.fotoPath = _imageFile!.path;
      }
      HiveDB.motorsBox.putAt(widget.index, widget.motor);
      isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Data motor berhasil disimpan!")),
    );
  }

  void _deleteMotor(BuildContext context) {
    if (widget.motor.fotoPath != null && File(widget.motor.fotoPath!).existsSync()) {
      File(widget.motor.fotoPath!).deleteSync();
    }
    HiveDB.motorsBox.deleteAt(widget.index);
    Navigator.pop(context);
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'motor_${widget.motor.idMotor}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(picked.path).copy('${appDir.path}/$fileName');
      setState(() {
        _imageFile = savedImage;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Foto siap disimpan, klik Save!")),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'motor_${widget.motor.idMotor}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(picked.path).copy('${appDir.path}/$fileName');
      setState(() {
        _imageFile = savedImage;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gambar siap disimpan, klik Save!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orange;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.motor.brandMotor} ${widget.motor.modelMotor}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _saveEdit();
              } else {
                setState(() => isEditing = true);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(context: context, builder: (_) => AlertDialog(
                title: Text("Hapus Motor?"),
                content: Text("Yakin ingin hapus data ini?"),
                actions: [
                  TextButton(
                    child: Text("Batal"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text("Hapus"),
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteMotor(context);
                    },
                  ),
                ],
              ));
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Card untuk gambar motor
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_imageFile!, width: 200, height: 200, fit: BoxFit.cover),
                          )
                        : Icon(Icons.motorcycle, size: 120, color: orange),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.camera_alt),
                          tooltip: _imageFile == null ? "Ambil Foto" : "Retake Foto",
                          onPressed: isEditing ? _takePhoto : null,
                          color: orange,
                          iconSize: 32,
                        ),
                        SizedBox(width: 12),
                        IconButton(
                          icon: Icon(Icons.photo_album),
                          tooltip: "Pilih dari Galeri",
                          onPressed: isEditing ? _pickFromGallery : null,
                          color: orange,
                          iconSize: 32,
                        ),
                        SizedBox(width: 12),
                        if (_imageFile != null && isEditing)
                          IconButton(
                            icon: Icon(Icons.save),
                            tooltip: "Save Gambar",
                            onPressed: _saveEdit,
                            color: Colors.green,
                            iconSize: 32,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 18),
            // Card untuk data motor
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildField("Brand Motor", brandController, isEditing),
                    _buildField("Model Motor", modelController, isEditing),
                    _buildField("Plat Nomor", platController, isEditing),
                    _buildField("Tahun", tahunController, isEditing, keyboardType: TextInputType.number),
                    _buildField("Pemilik", pemilikController, isEditing),
                  ],
                ),
              ),
            ),
            SizedBox(height: 18),
            // Card untuk tombol ke Service Record Page
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Service Records",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: orange,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.list),
                      label: Text("Lihat Semua"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ServiceRecordPage(motor: widget.motor),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        foregroundColor: Colors.white,
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
  }

  Widget _buildField(String label, TextEditingController controller, bool enabled, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        enabled: enabled,
        keyboardType: keyboardType,
      ),
    );
  }
}