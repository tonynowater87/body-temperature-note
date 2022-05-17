// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveRecordAdapter extends TypeAdapter<HiveRecord> {
  @override
  final int typeId = 1;

  @override
  HiveRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveRecord()
      ..temperature = fields[0] as double
      ..dateTime = fields[1] as DateTime;
  }

  @override
  void write(BinaryWriter writer, HiveRecord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.temperature)
      ..writeByte(1)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
