import 'dart:io';

import 'package:args/args.dart';
import 'package:awesome_generator/awesome_generator.dart';
import 'package:github/github.dart';

class AwesomeGitHub extends AwesomeSource {
  AwesomeGitHub() : super('github');

  late final GitHub _client;

  @override
  void init(ArgParser parser) {
    parser.addOption(
      'github-token',
      valueHelp: 'token',
      defaultsTo: Platform.environment['GITHUB_TOKEN'],
      help: 'GitHub token (defaults to GITHUB_TOKEN)',
    );
  }

  @override
  void parse(ArgResults options) {
    _client = GitHub(auth: Authentication.withToken(options['github-token']));
  }

  @override
  Future<Map<String, dynamic>?> load(String name) {
    return _client.repositories
        .getRepository(RepositorySlug.full(name))
        .then((r) => r.toJson()..remove('owner'));
  }

  @override
  void dispose() => _client.dispose();
}
