import 'package:json_annotation/json_annotation.dart';
import '../model/booking_api_model.dart';

part 'get_all_booking_dto.g.dart';

@JsonSerializable()
class GetAllBookingDto {
  final bool success;

  // This tells json_serializable that the 'data' key in the JSON
  // corresponds to this 'data' field in the Dart class.
  final List<BookingApiModel> data;

  GetAllBookingDto({
    required this.success,
    required this.data,
  });

  // This factory constructor correctly parses the nested JSON.
  factory GetAllBookingDto.fromJson(Map<String, dynamic> json) {
    return GetAllBookingDto(
      success:
          json['success'] as bool? ?? false, // Safe parsing for the boolean

      data: (json['data'] as List<dynamic>?)
              ?.map((e) => BookingApiModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [], // Provide an empty list as a default
    );
  }

  // The toJson method is usually not needed for DTOs that only read data,
  // but it's good practice to have it.
  Map<String, dynamic> toJson() => _$GetAllBookingDtoToJson(this);
}
