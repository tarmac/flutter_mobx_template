import 'package:json_annotation/json_annotation.dart';

part 'dio_error_message.g.dart';

@JsonSerializable()
class DioErrorMessage {
  DioErrorMessage({
    this.showMessage = false,
    required this.message,
  });

  final bool showMessage;
  final String? message;

  factory DioErrorMessage.fromJson(Map<String, dynamic> json) => _$DioErrorMessageFromJson(json);

  Map<String, dynamic> toJson() => _$DioErrorMessageToJson(this);
}
