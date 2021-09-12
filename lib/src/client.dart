import 'dart:io';

import 'package:yaml/yaml.dart';

import 'cache.dart';
import 'source.dart';

class AwesomeClient {
  AwesomeClient({required this.sources, this.cache});

  final AwesomeCache? cache;
  final List<AwesomeSource> sources;

  Future<List<Map<String, dynamic>>> load(String path) async {
    final yaml = loadYaml(File(path).readAsStringSync()) as YamlMap;
    final entries = <Map<String, dynamic>>[];
    for (final category in yaml.keys) {
      entries.addAll(await _loadEntries(category, yaml[category]));
    }
    return entries;
  }

  Future<List<Map<String, dynamic>>> _loadEntries(
    String category,
    YamlList items,
  ) async {
    final entries = <Map<String, dynamic>>[];
    for (final item in items) {
      final entry = <String, dynamic>{
        'category': category,
        'name': item['name'],
        'url': item['url'],
        'description': item['description'],
      };
      for (final source in sources) {
        entry[source.name] = await _loadSource(item[source.name], source);
      }
      entries.add(entry);
    }
    entries.sort((a, b) {
      return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
    });
    return entries;
  }

  Future<Map<String, dynamic>?> _loadSource(
    String? name,
    AwesomeSource source,
  ) async {
    if (name == null) return null;

    final key = '${source.name}_$name'.replaceAll('/', '_');
    final cached = await cache?.get(key);
    if (cached != null) return cached;

    final json = await source.load(name);
    if (json != null) {
      await cache?.put(key, json);
    }
    return json;
  }
}
