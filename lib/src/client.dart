import 'dart:io';

import 'package:pub_api_client/pub_api_client.dart';
import 'package:yaml/yaml.dart';
import 'package:github/github.dart';

import 'entry.dart';

class AwesomeClient {
  AwesomeClient({String? token})
      : _github = GitHub(auth: Authentication.withToken(token));

  final GitHub _github;
  final PubClient _pub = PubClient();

  Future<List<AwesomeEntry>> load(String path) async {
    final yaml = loadYaml(File(path).readAsStringSync()) as YamlMap;
    final entries = <AwesomeEntry>[];
    for (final category in yaml.keys) {
      entries.addAll(await _readEntries(category, yaml[category]));
    }
    return entries;
  }

  void close() => _github.dispose();

  Future<List<AwesomeEntry>> _readEntries(
      String category, YamlList items) async {
    final entries = <AwesomeEntry>[];
    for (final item in items) {
      entries.add(AwesomeEntry(
        category: category,
        name: item['name'],
        url: item['url'],
        description: item['description'],
        pub: await _readPub(item['pub']),
        github: await _readGitHub(item['github']),
      ));
    }
    entries.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return entries;
  }

  Future<Map<String, dynamic>?> _readGitHub(String? repo) async {
    if (repo == null) return null;
    return _github.repositories
        .getRepository(RepositorySlug.full(repo))
        .then((r) => r.toJson());
  }

  Future<Map<String, dynamic>?> _readPub(String? package) async {
    if (package == null) return null;
    return _pub.packageInfo(package).then((p) => p.toJson());
  }
}
