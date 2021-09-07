import 'dart:io';

import 'package:args/args.dart';
import 'package:awesome_generator/awesome_generator.dart';

const _kAutoGenMark = '<!--AUTO-GENERATE-->';

Future<void> main(List<String> args) async {
  final parser = ArgParser();
  parser.addOption(
    'token',
    abbr: 't',
    valueHelp: 'token',
    defaultsTo: Platform.environment['GITHUB_TOKEN'],
    help: 'GitHub token (defaults to the GITHUB_TOKEN environment variable)',
  );
  parser.addOption(
    'input',
    abbr: 'i',
    valueHelp: 'path',
    defaultsTo: Directory.current.path,
    help: 'Path to awesome.yaml.',
  );
  parser.addOption(
    'output',
    abbr: 'o',
    valueHelp: 'path',
    defaultsTo: 'README.md',
    help: 'The output path',
  );
  final options = parser.parse(args);

  final token = options['token'] as String?;
  if (token == null || token.isEmpty) {
    print(
        'You must provide a GitHub token either using the --token command-line argument or GITHUB_TOKEN environment variable.');
    exit(1);
  }

  final localDb = await initLocalDb(options['input'], token);

  var file = File(options['output']);
  var content = file.readAsStringSync();

  final projectList = localDb.projects!.list()!;
  final packageList = localDb.packages!.list()!;

  projectList
      .sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
  packageList
      .sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

  var md = '''
## Packages

${packageList.map((e) => e.md).join('\n')}

## Projects

${projectList.map((e) => e.md).join('\n')}

''';

  var markIndexS = content.indexOf(_kAutoGenMark) + _kAutoGenMark.length;
  var markIndexE = content.lastIndexOf(_kAutoGenMark);

  var newContent = '';
  newContent += content.substring(0, markIndexS);
  newContent += '\n$md\n';
  newContent += content.substring(markIndexE);

  file.writeAsStringSync(newContent);
}
