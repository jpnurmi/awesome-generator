import 'dart:io';

import 'package:pub_api_client/pub_api_client.dart';
import 'package:yaml/yaml.dart';
import 'package:github/github.dart';

import 'cache.dart';
import 'entry.dart';

class AwesomeClient {
  AwesomeClient({required this.github, required this.pub, this.cache});

  final GitHub github;
  final PubClient pub;
  final AwesomeCache? cache;

  Future<List<AwesomeEntry>> load(String path) async {
    final yaml = loadYaml(File(path).readAsStringSync()) as YamlMap;
    final entries = <AwesomeEntry>[];
    for (final category in yaml.keys) {
      entries.addAll(await _readEntries(category, yaml[category]));
    }
    return entries;
  }

  Future<List<AwesomeEntry>> _readEntries(
      String category, YamlList items) async {
    final entries = <AwesomeEntry>[];
    for (final item in items) {
      entries.add(AwesomeEntry(
        category: category,
        name: item['name'],
        url: item['url'],
        description: item['description'],
        pub: await _readPubPackage(item['pub']),
        github: await _readGitHubRepo(item['github']),
      ));
    }
    entries.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return entries;
  }

  Future<Map<String, dynamic>?> _readGitHubRepo(String? repo) async {
    if (repo == null) return null;
    return _readCache(
      'github_${repo.replaceAll("/", "_")}',
      () => github.repositories
          .getRepository(RepositorySlug.full(repo))
          .then((r) => r.toJson()..remove('owner')),
    );
  }

  Future<Map<String, dynamic>?> _readPubPackage(String? package) async {
    if (package == null) return null;
    return _readCache(
      'pub_$package',
      () => pub.packageInfo(package).then((p) => {
            'name': p.name,
            'version': p.version,
            'description': p.description,
            'url': 'https://pub.dev/packages/$package'
          }),
    );
  }

  Future<Map<String, dynamic>?> _readCache(
    String key,
    Future<Map<String, dynamic>> Function() toJson,
  ) async {
    final cached = await cache?.get(key);
    if (cached != null) return cached;

    final json = await toJson();
    await cache?.put(key, json);
    return json;
  }
}
