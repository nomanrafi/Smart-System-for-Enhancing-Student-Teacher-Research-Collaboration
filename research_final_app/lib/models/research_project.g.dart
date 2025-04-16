// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'research_project.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResearchProjectAdapter extends TypeAdapter<ResearchProject> {
  @override
  final int typeId = 0;

  @override
  ResearchProject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResearchProject(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      status: fields[3] as String,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      progress: fields[6] as double,
      teamMembers: (fields[7] as List).cast<String>(),
      tags: (fields[8] as List).cast<String>(),
      fundingSource: fields[9] as String,
      budget: fields[10] as double,
      publications: (fields[11] as List).cast<String>(),
      documents: (fields[12] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ResearchProject obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.progress)
      ..writeByte(7)
      ..write(obj.teamMembers)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.fundingSource)
      ..writeByte(10)
      ..write(obj.budget)
      ..writeByte(11)
      ..write(obj.publications)
      ..writeByte(12)
      ..write(obj.documents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResearchProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
