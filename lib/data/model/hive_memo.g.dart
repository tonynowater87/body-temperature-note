// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_memo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMemoAdapter extends TypeAdapter<HiveMemo> {
  @override
  final int typeId = 2;

  @override
  HiveMemo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMemo()
      ..memo = fields[0] as String
      ..dateTime = fields[1] as DateTime;
  }

  @override
  void write(BinaryWriter writer, HiveMemo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.memo)
      ..writeByte(1)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMemoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
