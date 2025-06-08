// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceRecordModelAdapter extends TypeAdapter<ServiceRecordModel> {
  @override
  final int typeId = 2;

  @override
  ServiceRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceRecordModel(
      idRecord: fields[0] as int,
      idMotor: fields[1] as int,
      tanggalService: fields[2] as DateTime,
      kmService: fields[3] as int,
      jenisService: fields[4] as String,
      keterangan: fields[5] as String,
      biaya: fields[6] as int,
      daftarSparepart: (fields[7] as List).cast<String>(),
      zonaWaktu: fields[8] as String?,
      currency: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceRecordModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.idRecord)
      ..writeByte(1)
      ..write(obj.idMotor)
      ..writeByte(2)
      ..write(obj.tanggalService)
      ..writeByte(3)
      ..write(obj.kmService)
      ..writeByte(4)
      ..write(obj.jenisService)
      ..writeByte(5)
      ..write(obj.keterangan)
      ..writeByte(6)
      ..write(obj.biaya)
      ..writeByte(7)
      ..write(obj.daftarSparepart)
      ..writeByte(8)
      ..write(obj.zonaWaktu)
      ..writeByte(9)
      ..write(obj.currency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
