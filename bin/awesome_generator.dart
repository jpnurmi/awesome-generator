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
    defaultsTo: 'README.md',
    help: 'The output path',
  );
  parser.addOption(
    'template',
    valueHelp: 'path',
    defaultsTo: 'readme.tmpl',
    help: 'Path to readme.tmpl.',
  );

  final options = parser.parse(args);
  if (options['token'].isEmpty) {
    print(
        'You must provide a GitHub token either using the --token command-line argument or GITHUB_TOKEN environment variable.');
    exit(1);
  }

  final localDb = await initLocalDb(options['input'], options['token']);
  final projectList = localDb.projects!.list()!;
  final packageList = localDb.packages!.list()!;

  projectList
      .sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
  packageList
      .sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

  final context = Context.create();
  context.variables['packages'] = packageList.map((p) => p.toJson());
  context.variables['projects'] = projectList.map((p) => p.toJson());

  final content = File(options['template']).readAsStringSync();
  final template = Template.parse(context, Source.fromString(content));
  print(await template.render(context));

  final output = File(options['output']);
  output.writeAsStringSync(await template.render(context));
}
