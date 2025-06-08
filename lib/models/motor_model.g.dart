// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motor_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MotorModelAdapter extends TypeAdapter<MotorModel> {
  @override
  final int typeId = 1;

  @override
  MotorModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MotorModel(
      idMotor: fields[0] as int,
      brandMotor: fields[1] as String,
      modelMotor: fields[2] as String,
      platNomor: fields[3] as String,
      tahun: fields[4] as String,
      pemilik: fields[5] as String,
      fotoPath: fields[6] as String?,
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MotorModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.idMotor)
      ..writeByte(1)
      ..write(obj.brandMotor)
      ..writeByte(2)
      ..write(obj.modelMotor)
      ..writeByte(3)
      ..write(obj.platNomor)
      ..writeByte(4)
      ..write(obj.tahun)
      ..writeByte(5)
      ..write(obj.pemilik)
      ..writeByte(6)
      ..write(obj.fotoPath)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MotorModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
