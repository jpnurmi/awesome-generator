import 'dart:io';

import 'package:args/args.dart';
import 'package:awesome_generator/awesome_generator.dart';

import 'sources/github.dart';
import 'sources/pub.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser();
  parser.addFlag(
    'help',
    abbr: 'h',
    negatable: false,
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
    defaultsTo: 'awesome.tmpl',
    help: 'Path to awesome.tmpl.',
  );
  parser.addOption(
    'cache',
    valueHelp: 'path',
    defaultsTo: '${Directory.systemTemp.path}/awesome',
    help: 'Path to cache.',
  );
  parser.addFlag(
    'no-cache',
    negatable: false,
    defaultsTo: false,
    help: 'Disable the cache.',
  );

  final sources = [AwesomeGitHub(), AwesomePub()];
  for (final source in sources) {
    source.init(parser);
  }

  final options = parser.parse(args);

  if (options['help'] == true || options.rest.isEmpty) {
    print('Usage: awesome-generator <awesome.yaml(s)>\n');
    print(parser.usage);
    return;
  }

  for (final source in sources) {
    source.parse(options);
  }

  final client = AwesomeClient(
    sources: sources,
    cache: AwesomeCache.fromPath(options['cache']),
  );

  final entries = <Map<String, dynamic>>[];
  for (final file in options.rest) {
    entries.addAll(await client.load(file));
  }

  final generator = AwesomeGenerator(
    template: options['template'],
    entries: entries,
  );
  await generator.generate(options['output']);

  for (final source in sources) {
    source.dispose();
  }
}
