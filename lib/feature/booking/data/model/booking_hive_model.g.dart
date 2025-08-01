// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingHiveModelAdapter extends TypeAdapter<BookingHiveModel> {
  @override
  final int typeId = 1;

  @override
  BookingHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingHiveModel(
      id: fields[0] as String?,
      customerName: fields[1] as String?,
      serviceType: fields[2] as String?,
      bikeModel: fields[3] as String?,
      date: fields[4] as DateTime?,
      notes: fields[5] as String?,
      totalCost: fields[6] as double?,
      status: fields[7] as String?,
      paymentStatus: fields[8] as String?,
      isPaid: fields[9] as bool?,
      paymentMethod: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookingHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerName)
      ..writeByte(2)
      ..write(obj.serviceType)
      ..writeByte(3)
      ..write(obj.bikeModel)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.totalCost)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.paymentStatus)
      ..writeByte(9)
      ..write(obj.isPaid)
      ..writeByte(10)
      ..write(obj.paymentMethod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
