import 'dart:io';

import 'package:args/args.dart';
import 'package:awesome_generator/awesome_generator.dart';
import 'package:github/github.dart';
import 'package:path/path.dart' as p;
import 'package:pub_api_client/pub_api_client.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser();
  parser.addOption(
    'token',
    valueHelp: 'token',
    defaultsTo: Platform.environment['GITHUB_TOKEN'],
    help: 'GitHub token (defaults to the GITHUB_TOKEN environment variable)',
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

  final options = parser.parse(args);

  final github = GitHub(auth: Authentication.withToken(options['token']));

  final client = AwesomeClient(
    github: github,
    pub: PubClient(),
    cache: options['no-cache'] == true ? null : AwesomeCache(options['cache']),
  );

  final entries = <AwesomeEntry>[];
  for (final file in options.rest) {
    entries.addAll(await client.load(file));
  }

  final generator = AwesomeGenerator(
    template: options['template'],
    entries: entries,
  );
  await generator.generate(options['output']);

  github.dispose();
}
