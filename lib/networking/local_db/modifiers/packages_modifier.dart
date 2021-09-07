import '../../../awesome_generator.dart';

import '../local_db.dart';

class PackagesModifier {
  final DbData? dbData;

  PackagesModifier(this.dbData);

  String? _name;

  void setName(String? name) {
    _name = name;
  }

  List<Package>? get _packageList {
    if (dbData!.packageList == null) {
      dbData!.packageList = [];
    }
    return dbData!.packageList;
  }

  int get _packageIndex {
    return dbData!.packageList!.indexWhere((e) => e.name == _name);
  }

  List<Package>? list({
    bool Function(Package element)? where,
  }) {
    if (where != null) {
      return _packageList!.where(where).toList();
    }
    return _packageList;
  }

  Package get() {
    return _packageList![_packageIndex];
  }

  bool exists() {
    return _packageIndex != -1;
  }
}
