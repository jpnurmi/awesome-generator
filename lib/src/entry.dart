import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';

@freezed
class AwesomeEntry with _$AwesomeEntry {
  const factory AwesomeEntry({
    required String category,
    required String name,
    String? url,
    String? description,
    Map<String, dynamic>? pub,
    Map<String, dynamic>? github,
  }) = _AwesomeEntry;

  factory AwesomeEntry.fromJson(Map<String, dynamic> json) =>
      _$AwesomeEntryFromJson(json);
}
