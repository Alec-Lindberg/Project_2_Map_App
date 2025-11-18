// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_visit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StateVisitAdapter extends TypeAdapter<StateVisit> {
  @override
  final int typeId = 0;

  @override
  StateVisit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StateVisit(
      code: fields[0] as String,
      visited: fields[1] as bool,
      favoriteThing: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StateVisit obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.visited)
      ..writeByte(2)
      ..write(obj.favoriteThing);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateVisitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
