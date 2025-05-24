// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WYRQuestionAdapter extends TypeAdapter<WYRQuestion> {
  @override
  final int typeId = 1;

  @override
  WYRQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WYRQuestion(
      id: fields[0] as String,
      questionText: fields[1] as String,
      optionA: fields[2] as String,
      optionB: fields[3] as String,
      intensity: fields[4] as QuestionIntensity,
    );
  }

  @override
  void write(BinaryWriter writer, WYRQuestion obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.questionText)
      ..writeByte(2)
      ..write(obj.optionA)
      ..writeByte(3)
      ..write(obj.optionB)
      ..writeByte(4)
      ..write(obj.intensity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WYRQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestionIntensityAdapter extends TypeAdapter<QuestionIntensity> {
  @override
  final int typeId = 0;

  @override
  QuestionIntensity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestionIntensity.sweet;
      case 1:
        return QuestionIntensity.flirty;
      case 2:
        return QuestionIntensity.dirty;
      default:
        return QuestionIntensity.sweet;
    }
  }

  @override
  void write(BinaryWriter writer, QuestionIntensity obj) {
    switch (obj) {
      case QuestionIntensity.sweet:
        writer.writeByte(0);
        break;
      case QuestionIntensity.flirty:
        writer.writeByte(1);
        break;
      case QuestionIntensity.dirty:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionIntensityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
