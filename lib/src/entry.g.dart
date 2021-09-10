// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AwesomeEntry _$$_AwesomeEntryFromJson(Map<String, dynamic> json) =>
    _$_AwesomeEntry(
      name: json['name'] as String,
      url: json['url'] as String?,
      description: json['description'] as String?,
      pub: json['pub'] as Map<String, dynamic>?,
      github: json['github'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$_AwesomeEntryToJson(_$_AwesomeEntry instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'description': instance.description,
      'pub': instance.pub,
      'github': instance.github,
    };
