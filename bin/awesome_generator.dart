import 'dart:io';

import 'package:args/args.dart';
import 'package:awesome_generator/awesome_generator.dart';
import 'package:liquid_engine/liquid_engine.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser();
  parser.addOption(
    'token',
    valueHelp: 'token',
    defaultsTo: Platform.environment['GITHUB_TOKEN'],
    help: 'GitHub token (defaults to the GITHUB_TOKEN environment variable)',
  );
  parser.addOption(
    'input',
    abbr: 'i',
    valueHelp: 'path',
    defaultsTo: 'awesome.yaml',
    help: 'Path to awesome.yaml.',
  );
  parser.addOption(
    'output',
    abbr: 'o',
    valueHelp: 'path',
    help: 'The output path (defaults to stdout)',
  );
  parser.addOption(
    'template',
    valueHelp: 'path',
    defaultsTo: 'readme.tmpl',
    help: 'Path to readme.tmpl.',
  );

  final options = parser.parse(args);

  final localDb = await initLocalDb(options['input'], options['token']);
  final projectList = localDb.projects!;
  final packageList = localDb.packages!;

  projectList
      .sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
  packageList
      .sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

  final context = Context.create();
  context.variables['packages'] = packageList.map((p) => p.toJson());
  context.variables['projects'] = projectList.map((p) => p.toJson());

  final content = File(options['template']).readAsStringSync();
  final template = Template.parse(context, Source.fromString(content));

  output(options['output']).write(await template.render(context));
}

IOSink output(String? output) {
  if (output == null) {
    return stdout;
  }
  return File(output).openWrite(mode: FileMode.writeOnly);
}
