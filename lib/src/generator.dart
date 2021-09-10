import 'dart:io';

import 'package:liquid_engine/liquid_engine.dart';

import 'entry.dart';

class AwesomeGenerator {
  AwesomeGenerator({
    required this.template,
    required this.entries,
  });

  final String template;
  final List<AwesomeEntry> entries;

  Future<void> generate(String? path) async {
    final context = Context.create();
    context.variables['entries'] = entries.map((p) => p.toJson());

    final content = File(template).readAsStringSync();
    final parsed = Template.parse(context, Source.fromString(content));
    _output(path).write(await parsed.render(context));
  }

  IOSink _output(String? output) {
    if (output == null) {
      return stdout;
    }
    return File(output).openWrite(mode: FileMode.writeOnly);
  }
}
