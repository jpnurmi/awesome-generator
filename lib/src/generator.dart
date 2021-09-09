import 'dart:io';

import 'package:liquid_engine/liquid_engine.dart';

import 'entry.dart';

class AwesomeGenerator {
  AwesomeGenerator({
    required this.template,
    required this.packages,
    required this.projects,
  });

  final String template;
  final List<AwesomeEntry> packages;
  final List<AwesomeEntry> projects;

  Future<void> generate(String? path) async {
    final context = Context.create();
    context.variables['packages'] = packages.map((p) => p.toJson());
    context.variables['projects'] = projects.map((p) => p.toJson());

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
