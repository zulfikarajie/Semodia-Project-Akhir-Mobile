import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/motor_model.dart';
import 'package:hive/hive.dart';

class MotorFormPage extends StatefulWidget {
  final MotorModel? motor; // null jika tambah, isi jika edit

  const MotorFormPage({Key? key, this.motor}) : super(key: key);

  @override
  State<MotorFormPage> createState() => _MotorFormPageState();
}

class _MotorFormPageState extends State<MotorFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _modelController;
  late TextEditingController _platController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController(text: widget.motor?.modelMotor ?? '');
    _platController = TextEditingController(text: widget.motor?.platNomor ?? '');
    _imagePath = widget.motor?.fotoPath;
  }

  @override
  void dispose() {
    _modelController.dispose();
    _platController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Simpan file ke direktori aplikasi
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
      setState(() {
        _imagePath = savedImage.path;
      });
    }
  }

  void _deleteImage() {
    if (_imagePath != null) {
      final file = File(_imagePath!);
      if (file.existsSync()) {
        file.deleteSync();
      }
      setState(() {
        _imagePath = null;
      });
    }
  }

  Future<void> _saveMotor() async {
    if (_formKey.currentState!.validate()) {
      final box = Hive.box<MotorModel>('motors');
      if (widget.motor == null) {
        // Tambah baru
        final newMotor = MotorModel(
          idMotor: DateTime.now().millisecondsSinceEpoch,
          brandMotor: '', // tambahkan field lain sesuai kebutuhan
          modelMotor: _modelController.text,
          platNomor: _platController.text,
          tahun: '',
          fotoPath: _imagePath,
        );
        await box.add(newMotor);
      } else {
        // Edit
        widget.motor!
          ..modelMotor = _modelController.text
          ..platNomor = _platController.text
          ..fotoPath = _imagePath
          ..save();
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.motor == null ? 'Tambah Motor' : 'Edit Motor'),
        actions: [
          if (_imagePath != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteImage,
              tooltip: 'Hapus Gambar',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _imagePath != null
                    ? Image.file(File(_imagePath!), height: 150, fit: BoxFit.cover)
                    : Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: Icon(Icons.camera_alt, size: 48, color: Colors.grey[700]),
                      ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _modelController,
                decoration: InputDecoration(labelText: 'Model Motor'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _platController,
                decoration: InputDecoration(labelText: 'Plat Nomor'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveMotor,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}