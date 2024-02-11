//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class LooseTypeMappers extends TypeMappers {
  //
  //
  //

  static final instance = LooseTypeMappers._();

  //
  //
  //

  LooseTypeMappers._();

  //
  //
  //

  @override
  TTypeMappers get collectionFromMappers => newTypeMappers({
        r"^Map[\?]?$": (e) {
          if (e is! CollectionMapperEvent) throw TypeError();
          return "letMap(${e.name})?.map((${e.args}) => MapEntry(${e.hashes},),).nonNulls.nullIfEmpty?.cast()";
        },
        r"^Iterable[\?]?$": (e) {
          if (e is! CollectionMapperEvent) throw TypeError();
          return "letIterable(${e.name})?.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.cast()";
        },
        r"^List[\?]?$": (e) {
          if (e is! CollectionMapperEvent) throw TypeError();
          return "letList(${e.name})?.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toList().cast()";
        },
        r"^Set[\?]?$": (e) {
          if (e is! CollectionMapperEvent) throw TypeError();
          return "letSet(${e.name})?.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toSet().cast()";
        },
      });

  //
  //
  //

  @override
  TTypeMappers get collectionToMappers => newTypeMappers({
        r"^Map[\?]?$": (e) {
          if (e is! CollectionMapperEvent) throw TypeError();
          return "${e.name}?.map((${e.args}) => MapEntry(${e.hashes},),).nonNulls.nullIfEmpty";
        },
        r"^Iterable|List|Set[\?]?$": (e) {
          if (e is! CollectionMapperEvent) throw TypeError();
          return "${e.name}?.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toList()";
        },
      });

  //
  //
  //

  @override
  TTypeMappers get objectFromMappers => newTypeMappers({
        r"^dynamic[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}";
        },
        r"^String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty";
        },
        r"^LowerCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toLowerCase()";
        },
        r"^UpperCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toUpperCase()";
        },
        r"^LowerSnakeCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toLowerSnakeCase()";
        },
        r"^UpperSnakeCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toUpperSnakeCase()";
        },
        r"^LowerKebabCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toLowerKebabCase()";
        },
        r"^UpperKebabCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toUpperKebabCase()";
        },
        r"^CamelCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toCamelCase()";
        },
        r"^PascalCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toPascalCase()";
        },
        r"^bool[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "letBool(${e.name})";
        },
        r"^int[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "letInt(${e.name})";
        },
        r"^double[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "letDouble(${e.name})";
        },
        r"^num[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "letNum(${e.name})";
        },
        r"^Timestamp[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "() { final a = ${e.name}; return a is Timestamp ? a: null; }()";
        },
        r"^DateTime[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "() { final a = ${e.name}; return a != null ? DateTime.tryParse(a)?.toUtc(): null; }()";
        },
        r"^Duration[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.tryParseDuration()";
        },
        r"^Uri[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "(){ final a = ${e.name}; return a is String ? a.trim().nullIfEmpty?.toUri(): null; }()";
        },
        r"^(\w+Type)[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          final typeName = e.matchGroups?.elementAt(1);
          return "nameTo$typeName(letAs<String>(${e.name}))";
        },
        r"^(Model\w+)[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          final typeName = e.matchGroups?.elementAt(1);
          return "() { final a = letMap<String, dynamic>(${e.name}); return a != null ? $typeName.fromJson(a): null; }()";
        },
        r"^\w+[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}";
        },
      });

  //
  //
  //

  @override
  TTypeMappers get objectToMappers => newTypeMappers({
        r"^String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty";
        },
        r"^LowerCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toLowerCase()";
        },
        r"^UpperCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toUpperCase()";
        },
        r"^LowerSnakeCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toLowerSnakeCase()";
        },
        r"^UpperSnakeCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toUpperSnakeCase()";
        },
        r"^LowerKebabCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toLowerKebabCase()";
        },
        r"^UpperKebabCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toUpperKebabCase()";
        },
        r"^CamelCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toCamelCase()";
        },
        r"^PascalCase-String[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString().trim().nullIfEmpty?.toPascalCase()";
        },
        r"^dynamic|bool|int|double|num|Timestamp[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}";
        },
        r"^DateTime[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toUtc()?.toIso8601String()";
        },
        r"^Duration|Uri[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toString()";
        },
        r"^(\w+Type)[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.name";
        },
        r"^(Model\w+)[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}?.toJson()";
        },
        r"^\w+[\?]?$": (e) {
          if (e is! ObjectMapperEvent) throw TypeError();
          return "${e.name}";
        },
      });
}
