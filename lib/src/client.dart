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

  final packages = <AwesomeEntry>[];
  final projects = <AwesomeEntry>[];

  Future<void> load(String path) async {
    final yaml = loadYaml(File(path).readAsStringSync()) as YamlMap;
    packages.addAll(await _readEntries(yaml['packages']));
    projects.addAll(await _readEntries(yaml['projects']));
  }

  void close() => _github.dispose();

  Future<List<AwesomeEntry>> _readEntries(YamlList items) async {
    final entries = <AwesomeEntry>[];
    for (final item in items) {
      entries.add(AwesomeEntry(
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

  Future<Repository?> _readGitHub(String? repo) async {
    if (repo == null) return null;
    return _github.repositories.getRepository(RepositorySlug.full(repo));
  }

  Future<PubPackage?> _readPub(String? package) async {
    if (package == null) return null;
    return _pub.packageInfo(package);
  }
}
