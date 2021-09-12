import 'package:args/args.dart';

abstract class AwesomeSource {
  const AwesomeSource(this.name);

  final String name;

  void init(ArgParser parser) {}
  void parse(ArgResults options) {}
  Future<Map<String, dynamic>?> load(String name);
  void dispose() {}
}
