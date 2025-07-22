// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fish_spot.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FishSpotAdapter extends TypeAdapter<FishSpot> {
  @override
  final int typeId = 0;

  @override
  FishSpot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FishSpot(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      title: fields[2] as String,
      description: fields[3] as String,
      date: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FishSpot obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FishSpotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
