import 'dart:convert';
import 'dart:io';

import 'package:pub_api_client/pub_api_client.dart';
import 'package:yaml/yaml.dart';
import 'package:github/github.dart';

import '../../generator.dart';
import 'modifiers/projects_modifier.dart';
import 'modifiers/packages_modifier.dart';

export 'modifiers/projects_modifier.dart';
export 'modifiers/packages_modifier.dart';

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

  ProjectsModifier? _projectsModifier;
  PackagesModifier? _packagesModifier;

  PubClient? get pubClient {
    if (_pubClient == null) _pubClient = PubClient();
    return _pubClient;
  }

  GitHub? get githubClient {
    if (_githubClient == null) {
      _githubClient = GitHub(
        auth: Authentication.withToken(githubToken),
      );
    }
    return _githubClient;
  }

  Future<List<Project>> _readProjectList(YamlList items) async {
    List<Project> projectList = [];
    for (var item in items) {
      Project project = Project.fromJson(Map<String, dynamic>.from(item));

      if (project.description == null) {
        String cacheKey = 'github#${project.repo}';
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
    List<Package> packageList = [];
    for (var item in items) {
      Package package = Package.fromJson(Map<String, dynamic>.from(item));

      if (package.description == null) {
        String cacheKey = 'pub#${package.name}';

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
    this.dbData = defaultDbData;

    File _cacheFile = File('.cache.json');
    if (_cacheFile.existsSync()) {
      String cacheJsonString = await _cacheFile.readAsString();
      _cacheMap = json.decode(cacheJsonString);
    }

    List<Project> projectList;
    List<Package> packageList;

    File file = File(path);
    String content = file.readAsStringSync();
    YamlMap doc = loadYaml(content);

    projectList = await _readProjectList(doc['projects'] as YamlList);
    packageList = await _readPackageList(doc['packages'] as YamlList);

    this.dbData!.projectList = []..addAll(projectList);
    this.dbData!.packageList = packageList;

    final String cacheJsonString = prettyJsonString(_cacheMap);
    _cacheFile.writeAsStringSync(cacheJsonString);

    return this.dbData;
  }

  ProjectsModifier? get projects {
    return project(null);
  }

  ProjectsModifier? project(String? name) {
    if (_projectsModifier == null) {
      _projectsModifier = ProjectsModifier(this.dbData);
    }
    _projectsModifier!.setName(name);
    return _projectsModifier;
  }

  PackagesModifier? get packages {
    return package(null);
  }

  PackagesModifier? package(String? name) {
    if (_packagesModifier == null) {
      _packagesModifier = PackagesModifier(this.dbData);
    }
    _packagesModifier!.setName(name);
    return _packagesModifier;
  }
}

class DbData {
  List<Project>? projectList;
  List<Package>? packageList;

  DbData({
    this.projectList,
    this.packageList,
  });

  factory DbData.fromJson(Map<String, dynamic> json) {
    List<Project> projectList = [];
    List<Package> packageList = [];

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
