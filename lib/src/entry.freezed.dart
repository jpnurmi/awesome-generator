// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AwesomeEntry _$AwesomeEntryFromJson(Map<String, dynamic> json) {
  return _AwesomeEntry.fromJson(json);
}

/// @nodoc
class _$AwesomeEntryTearOff {
  const _$AwesomeEntryTearOff();

  _AwesomeEntry call(
      {required String name,
      String? url,
      String? description,
      Map<String, dynamic>? pub,
      Map<String, dynamic>? github}) {
    return _AwesomeEntry(
      name: name,
      url: url,
      description: description,
      pub: pub,
      github: github,
    );
  }

  AwesomeEntry fromJson(Map<String, Object> json) {
    return AwesomeEntry.fromJson(json);
  }
}

/// @nodoc
const $AwesomeEntry = _$AwesomeEntryTearOff();

/// @nodoc
mixin _$AwesomeEntry {
  String get name => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get pub => throw _privateConstructorUsedError;
  Map<String, dynamic>? get github => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AwesomeEntryCopyWith<AwesomeEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AwesomeEntryCopyWith<$Res> {
  factory $AwesomeEntryCopyWith(
          AwesomeEntry value, $Res Function(AwesomeEntry) then) =
      _$AwesomeEntryCopyWithImpl<$Res>;
  $Res call(
      {String name,
      String? url,
      String? description,
      Map<String, dynamic>? pub,
      Map<String, dynamic>? github});
}

/// @nodoc
class _$AwesomeEntryCopyWithImpl<$Res> implements $AwesomeEntryCopyWith<$Res> {
  _$AwesomeEntryCopyWithImpl(this._value, this._then);

  final AwesomeEntry _value;
  // ignore: unused_field
  final $Res Function(AwesomeEntry) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? url = freezed,
    Object? description = freezed,
    Object? pub = freezed,
    Object? github = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      pub: pub == freezed
          ? _value.pub
          : pub // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      github: github == freezed
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
abstract class _$AwesomeEntryCopyWith<$Res>
    implements $AwesomeEntryCopyWith<$Res> {
  factory _$AwesomeEntryCopyWith(
          _AwesomeEntry value, $Res Function(_AwesomeEntry) then) =
      __$AwesomeEntryCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      String? url,
      String? description,
      Map<String, dynamic>? pub,
      Map<String, dynamic>? github});
}

/// @nodoc
class __$AwesomeEntryCopyWithImpl<$Res> extends _$AwesomeEntryCopyWithImpl<$Res>
    implements _$AwesomeEntryCopyWith<$Res> {
  __$AwesomeEntryCopyWithImpl(
      _AwesomeEntry _value, $Res Function(_AwesomeEntry) _then)
      : super(_value, (v) => _then(v as _AwesomeEntry));

  @override
  _AwesomeEntry get _value => super._value as _AwesomeEntry;

  @override
  $Res call({
    Object? name = freezed,
    Object? url = freezed,
    Object? description = freezed,
    Object? pub = freezed,
    Object? github = freezed,
  }) {
    return _then(_AwesomeEntry(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      pub: pub == freezed
          ? _value.pub
          : pub // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      github: github == freezed
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AwesomeEntry implements _AwesomeEntry {
  const _$_AwesomeEntry(
      {required this.name, this.url, this.description, this.pub, this.github});

  factory _$_AwesomeEntry.fromJson(Map<String, dynamic> json) =>
      _$$_AwesomeEntryFromJson(json);

  @override
  final String name;
  @override
  final String? url;
  @override
  final String? description;
  @override
  final Map<String, dynamic>? pub;
  @override
  final Map<String, dynamic>? github;

  @override
  String toString() {
    return 'AwesomeEntry(name: $name, url: $url, description: $description, pub: $pub, github: $github)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AwesomeEntry &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.url, url) ||
                const DeepCollectionEquality().equals(other.url, url)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.pub, pub) ||
                const DeepCollectionEquality().equals(other.pub, pub)) &&
            (identical(other.github, github) ||
                const DeepCollectionEquality().equals(other.github, github)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(url) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(pub) ^
      const DeepCollectionEquality().hash(github);

  @JsonKey(ignore: true)
  @override
  _$AwesomeEntryCopyWith<_AwesomeEntry> get copyWith =>
      __$AwesomeEntryCopyWithImpl<_AwesomeEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AwesomeEntryToJson(this);
  }
}

abstract class _AwesomeEntry implements AwesomeEntry {
  const factory _AwesomeEntry(
      {required String name,
      String? url,
      String? description,
      Map<String, dynamic>? pub,
      Map<String, dynamic>? github}) = _$_AwesomeEntry;

  factory _AwesomeEntry.fromJson(Map<String, dynamic> json) =
      _$_AwesomeEntry.fromJson;

  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String? get url => throw _privateConstructorUsedError;
  @override
  String? get description => throw _privateConstructorUsedError;
  @override
  Map<String, dynamic>? get pub => throw _privateConstructorUsedError;
  @override
  Map<String, dynamic>? get github => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AwesomeEntryCopyWith<_AwesomeEntry> get copyWith =>
      throw _privateConstructorUsedError;
}
