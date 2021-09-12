import 'package:awesome_generator/awesome_generator.dart';
import 'package:pub_api_client/pub_api_client.dart';

class AwesomePub extends AwesomeSource {
  AwesomePub() : super('pub');

  final PubClient _client = PubClient();

  @override
  Future<Map<String, dynamic>?> load(String name) {
    return _client.packageInfo(name).then((p) => {
          'name': p.name,
          'version': p.version,
          'description': p.description,
          'url': 'https://pub.dev/packages/$name'
        });
  }
}
