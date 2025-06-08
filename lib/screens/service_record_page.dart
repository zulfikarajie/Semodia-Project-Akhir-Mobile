import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../models/service_record_model.dart';
import '../models/motor_model.dart';

const List<Map<String, dynamic>> timezones = [
  {'label': 'WIB', 'offset': 7},
  {'label': 'WITA', 'offset': 8},
  {'label': 'WIT', 'offset': 9},
  {'label': 'London', 'offset': 0},
];

const List<Map<String, dynamic>> currencies = [
  {'label': 'IDR', 'rate': 1},
  {'label': 'USD', 'rate': 0.000062},
  {'label': 'JPY', 'rate': 0.0098},
  {'label': 'EUR', 'rate': 0.000057},
];

String formatServiceTime(DateTime localDateTime, String timezoneLabel) {
  final inputOffset = 7;
  final targetOffset = timezones.firstWhere((tz) => tz['label'] == timezoneLabel, orElse: () => timezones[0])['offset'];
  final diff = targetOffset - inputOffset;
  final converted = localDateTime.add(Duration(hours: diff));
  return DateFormat('yyyy-MM-dd HH:mm').format(converted);
}

String formatCurrency(int amount, String currencyLabel) {
  final rate = currencies.firstWhere((c) => c['label'] == currencyLabel, orElse: () => currencies[0])['rate'] as num;
  final converted = amount * rate;
  final format = NumberFormat.currency(
    locale: 'en',
    symbol: currencyLabel == 'IDR' ? 'Rp' : currencyLabel + ' ',
    decimalDigits: currencyLabel == 'IDR' ? 0 : 2,
  );
  return format.format(converted);
}

class ServiceRecordPage extends StatefulWidget {
  final MotorModel motor;
  const ServiceRecordPage({required this.motor});

  @override
  State<ServiceRecordPage> createState() => _ServiceRecordPageState();
}

class _ServiceRecordPageState extends State<ServiceRecordPage> {
  late Box<ServiceRecordModel> serviceRecordBox;
  List<ServiceRecordModel> serviceRecords = [];
  String _selectedTimezone = 'WIB';
  String _selectedCurrency = 'IDR';

  @override
  void initState() {
    super.initState();
    serviceRecordBox = Hive.box<ServiceRecordModel>('service_records');
    _loadServiceRecords();
  }

  void _loadServiceRecords() {
    setState(() {
      serviceRecords = serviceRecordBox.values
          .where((record) => record.idMotor == widget.motor.idMotor)
          .toList()
        ..sort((a, b) => b.tanggalService.compareTo(a.tanggalService));
    });
  }

  void _showAddOrEditDialog({ServiceRecordModel? record, int? index}) async {
    String selectedJenis = record?.jenisService ?? 'Major';
    final keteranganController = TextEditingController(text: record?.keterangan ?? '');
    final kmController = TextEditingController(text: record?.kmService?.toString() ?? '');
    final biayaController = TextEditingController(text: record?.biaya?.toString() ?? '');
    final sparepartController = TextEditingController(
        text: record?.daftarSparepart.join(', ') ?? '');
    DateTime? selectedDate = record?.tanggalService;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(record == null ? "Tambah Service" : "Edit Service"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedJenis,
                  decoration: InputDecoration(labelText: "Jenis Service"),
                  items: ['Major', 'Minor']
                      .map((jenis) => DropdownMenuItem(value: jenis, child: Text(jenis)))
                      .toList(),
                  onChanged: (val) {
                    setStateDialog(() {
                      selectedJenis = val!;
                    });
                  },
                ),
                TextField(
                  controller: keteranganController,
                  decoration: InputDecoration(labelText: "Keterangan"),
                ),
                TextField(
                  controller: kmController,
                  decoration: InputDecoration(labelText: "KM Service"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                TextField(
                  controller: biayaController,
                  decoration: InputDecoration(labelText: "Biaya"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                TextField(
                  controller: sparepartController,
                  decoration: InputDecoration(labelText: "Sparepart (pisahkan dengan koma)"),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(selectedDate == null
                        ? "Tanggal: -"
                        : "Tanggal: ${DateFormat('yyyy-MM-dd HH:mm').format(selectedDate!)}"),
                    Spacer(),
                    TextButton(
                      child: Text("Pilih"),
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: selectedDate != null
                                ? TimeOfDay.fromDateTime(selectedDate!)
                                : TimeOfDay.now(),
                          );
                          setStateDialog(() {
                            if (pickedTime != null) {
                              selectedDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            } else {
                              selectedDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                              );
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Simpan"),
              onPressed: () {
                if (selectedJenis.isNotEmpty &&
                    selectedDate != null &&
                    kmController.text.isNotEmpty &&
                    biayaController.text.isNotEmpty &&
                    int.tryParse(kmController.text) != null &&
                    int.tryParse(biayaController.text) != null) {
                  if (record == null) {
                    final newRecord = ServiceRecordModel(
                      idRecord: DateTime.now().millisecondsSinceEpoch,
                      idMotor: widget.motor.idMotor,
                      tanggalService: selectedDate!,
                      kmService: int.tryParse(kmController.text) ?? 0,
                      jenisService: selectedJenis,
                      keterangan: keteranganController.text,
                      biaya: int.tryParse(biayaController.text) ?? 0,
                      daftarSparepart: sparepartController.text.isEmpty
                          ? []
                          : sparepartController.text.split(',').map((e) => e.trim()).toList(),
                    );
                    serviceRecordBox.add(newRecord);
                  } else {
                    record.tanggalService = selectedDate!;
                    record.kmService = int.tryParse(kmController.text) ?? 0;
                    record.jenisService = selectedJenis;
                    record.keterangan = keteranganController.text;
                    record.biaya = int.tryParse(biayaController.text) ?? 0;
                    record.daftarSparepart = sparepartController.text.isEmpty
                        ? []
                        : sparepartController.text.split(',').map((e) => e.trim()).toList();
                    record.save();
                  }
                  _loadServiceRecords();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteRecord(ServiceRecordModel record) async {
    await record.delete();
    _loadServiceRecords();
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.orange;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service Records',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: "Tambah Service",
            onPressed: () => _showAddOrEditDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
                    // ...existing code...
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text("Timezone: "),
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedTimezone,
                          items: timezones
                              .map<DropdownMenuItem<String>>((tz) => DropdownMenuItem<String>(
                                    value: tz['label'] as String,
                                    child: Text(tz['label'] as String),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedTimezone = val!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Row(
                    children: [
                      Text("Currency: "),
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedCurrency,
                          items: currencies
                              .map<DropdownMenuItem<String>>((c) => DropdownMenuItem<String>(
                                    value: c['label'] as String,
                                    child: Text(c['label'] as String),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedCurrency = val!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ...existing code...
          Expanded(
            child: serviceRecords.isEmpty
                ? Center(child: Text("Belum ada service records"))
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: serviceRecords.length,
                    itemBuilder: (context, i) {
                      final record = serviceRecords[i];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${record.jenisService} Service",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: orange,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    tooltip: "Edit",
                                    onPressed: () => _showAddOrEditDialog(record: record),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    tooltip: "Hapus",
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text("Hapus Service?"),
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
                                                _deleteRecord(record);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Tanggal: ${formatServiceTime(record.tanggalService, _selectedTimezone)}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Zona Waktu: $_selectedTimezone",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 8),
                              Text("KM: ${record.kmService}"),
                              Text("Keterangan: ${record.keterangan}"),
                              Text("Biaya: ${formatCurrency(record.biaya, _selectedCurrency)}"),
                              Text("Sparepart: ${record.daftarSparepart.join(', ')}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}