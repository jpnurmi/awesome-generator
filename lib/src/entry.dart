import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:github/github.dart';
import 'package:pub_api_client/pub_api_client.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';

@freezed
class AwesomeEntry with _$AwesomeEntry {
  const factory AwesomeEntry({
    required String name,
    String? url,
    String? description,
    PubPackage? pub,
    Repository? github,
  }) = _AwesomeEntry;

  factory AwesomeEntry.fromJson(Map<String, dynamic> json) =>
      _$AwesomeEntryFromJson(json);
}
