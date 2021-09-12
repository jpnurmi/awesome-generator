import 'package:path/path.dart' as p;
import 'package:stash/stash_api.dart';
import 'package:stash_file/stash_file.dart';

class AwesomeCache {
  static AwesomeCache? fromPath(String? path) {
    if (path == null) return null;
    return AwesomeCache._(path);
  }

  AwesomeCache._(this.path)
      : cache = newLocalFileCache(
            cacheName: p.basename(path), path: p.dirname(path));

  final String path;
  final Cache cache;

  Future<Map<String, dynamic>?> get(String key) async {
    final map = await cache.get(key) as Map?;
    return map?.cast<String, dynamic>();
  }

  Future<void> put(String key, Map<String, dynamic> entry) {
    return cache.put(key, entry);
  }
}
