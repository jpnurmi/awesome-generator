import 'dart:io';

import 'package:liquid_engine/liquid_engine.dart';

class AwesomeGenerator {
  AwesomeGenerator({
    required this.template,
    required this.entries,
  }) : categories = entries.map((entry) => entry['category'] as String).toSet();

  final String template;
  final List<Map<String, dynamic>> entries;
  final Set<String> categories;

  Future<void> generate(String? path) async {
    final context = Context.create();
    context.variables['entries'] = entries;
    for (final category in categories) {
      context.variables[category] =
          entries.where((e) => e['category'] == category).toList();
    }

    final content = File(template).readAsStringSync();
    final parsed = Template.parse(context, Source.fromString(content));
    _write(path, await parsed.render(context));
  }

  void _write(String? path, String content) {
    _output(path).write(content);
  }

  IOSink _output(String? output) {
    if (output == null) {
      return stdout;
    }
    return File(output).openWrite(mode: FileMode.writeOnly);
  }
}
