import 'dart:convert';

String prettyJsonString(dynamic json) {
  var encoder = JsonEncoder.withIndent('  ');
  var jsonString = encoder.convert(json);

  return jsonString;
}
