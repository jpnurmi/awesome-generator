import 'dart:convert';
import 'dart:io';

import 'package:pub_api_client/pub_api_client.dart';
import 'package:yaml/yaml.dart';
import 'package:github/github.dart';

import '../../awesome_generator.dart';

class LocalDb {
  final DbData? defaultDbData;

  LocalDb({
    this.defaultDbData,
    required this.githubToken,
  });

  DbData? dbData;
  String githubToken;

  Map<String, dynamic>? _cacheMap = {};

  PubClient? _pubClient;
  GitHub? _githubClient;

  PubClient? get pubClient {
    _pubClient ??= PubClient();
    return _pubClient;
  }

  GitHub? get githubClient {
    _githubClient ??= GitHub(
      auth: Authentication.withToken(githubToken),
    );
    return _githubClient;
  }

  Future<List<Project>> _readProjectList(YamlList items) async {
    var projectList = <Project>[];
    for (var item in items) {
      var project = Project.fromJson(Map<String, dynamic>.from(item));

      if (project.description == null) {
        var cacheKey = 'github#${project.repo}';
        Repository repository;
        if (_cacheMap!.containsKey(cacheKey)) {
          repository = Repository.fromJson(_cacheMap![cacheKey]);
        } else {
          repository = await githubClient!.repositories.getRepository(
            RepositorySlug(
                project.repo!.split('/')[0], project.repo!.split('/')[1]),
          );
          _cacheMap!.putIfAbsent(cacheKey, () => repository.toJson());
        }
        project.description = repository.description;
      }
      projectList.add(project);
    }
    return projectList;
  }

  Future<List<Package>> _readPackageList(YamlList items) async {
    var packageList = <Package>[];
    for (var item in items) {
      var package = Package.fromJson(Map<String, dynamic>.from(item));

      if (package.description == null) {
        var cacheKey = 'pub#${package.name}';

        PubPackage pubPackage;
        if (_cacheMap!.containsKey(cacheKey)) {
          pubPackage = PubPackage.fromJson(_cacheMap![cacheKey]);
        } else {
          pubPackage = await pubClient!.packageInfo(package.pub!);
          _cacheMap!.update(
            cacheKey,
            (_) => pubPackage.toJson(),
            ifAbsent: () => pubPackage.toJson(),
          );
        }
        package.description = pubPackage.description;
      }

      packageList.add(package);
    }
    return packageList;
  }

  Future<DbData?> read(String path) async {
    dbData = defaultDbData;

    var _cacheFile = File('.cache.json');
    if (_cacheFile.existsSync()) {
      var cacheJsonString = await _cacheFile.readAsString();
      _cacheMap = json.decode(cacheJsonString);
    }

    List<Project> projectList;
    List<Package> packageList;

    var file = File(path);
    var content = file.readAsStringSync();
    YamlMap doc = loadYaml(content);

    projectList = await _readProjectList(doc['projects'] as YamlList);
    packageList = await _readPackageList(doc['packages'] as YamlList);

    dbData!.projectList = [...projectList];
    dbData!.packageList = packageList;

    final cacheJsonString = prettyJsonString(_cacheMap);
    _cacheFile.writeAsStringSync(cacheJsonString);

    return dbData;
  }

  List<Project>? get projects => dbData!.projectList;
  List<Package>? get packages => dbData!.packageList;
}

class DbData {
  List<Project>? projectList;
  List<Package>? packageList;

  DbData({
    this.projectList,
    this.packageList,
  });

  factory DbData.fromJson(Map<String, dynamic> json) {
    var projectList = <Project>[];
    var packageList = <Package>[];

    if (json['projectList'] != null) {
      Iterable l = json['projectList'] as List;
      projectList = l.map((item) => Project.fromJson(item)).toList();
    }
    if (json['packageList'] != null) {
      Iterable l = json['packageList'] as List;
      packageList = l.map((item) => Package.fromJson(item)).toList();
    }

    return DbData(
      projectList: projectList,
      packageList: packageList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectList': (projectList ?? []).map((e) => e.toJson()).toList(),
      'packageList': (packageList ?? []).map((e) => e.toJson()).toList(),
    };
  }
}

Future<LocalDb> initLocalDb(String path, String githubToken) async {
  final localDb = LocalDb(
    defaultDbData: DbData(
      projectList: [],
      packageList: [],
    ),
    githubToken: githubToken,
  );
  await localDb.read(path);
  return localDb;
}
