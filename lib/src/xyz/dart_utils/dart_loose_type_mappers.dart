//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/src/xyz/_index.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class DartLooseTypeMappers extends TypeMappers {
  //
  //
  //

  static final instance = DartLooseTypeMappers._();

  //
  //
  //

  DartLooseTypeMappers._();

  //
  //
  //

  @override
  get collectionFromMappers => newTypeMappers<CollectionMapperEvent>({
        // ---------------------------------------------------------------------
        // Standard.
        // ---------------------------------------------------------------------
        r'^(Map)\??$': (e) {
          return 'letMap(${e.name})?.map((${e.args}) => MapEntry(${e.hashes},),).nonNulls.nullIfEmpty';
        },
        r'^(Iterable)\??$': (e) {
          return 'letIterable(${e.name})?.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty';
        },
        r'^(List)\??$': (e) {
          return 'letList(${e.name})?.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toList()';
        },
        r'^(Set)\??$': (e) {
          return 'letSet(${e.name})?.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toSet()';
        },
        r'^(Queue)\??$': (e) {
          return '(){ final a = letList(${e.name})?.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty; return a != null ? Queue.of(a): null; }()';
        },
      });

  //
  //
  //

  @override
  get collectionToMappers => newTypeMappers<CollectionMapperEvent>({
        // ---------------------------------------------------------------------
        // Standard.
        // ---------------------------------------------------------------------
        r'^(Map)\??$': (e) {
          return '${e.name}?.map((${e.args}) => MapEntry(${e.hashes},),).nonNulls.nullIfEmpty';
        },
        r'^(Iterable|List|Set|Queue)\??$': (e) {
          return '${e.name}?.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toList()';
        },
      });

  //
  //
  //

  @override
  get objectFromMappers => newTypeMappers<ObjectMapperEvent>({
        // ---------------------------------------------------------------------
        // Standard.
        // ---------------------------------------------------------------------
        r'^(dynamic)\??$': (e) {
          return '${e.name}';
        },
        r'^(String)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty';
        },
        r'^(bool)\??$': (e) {
          return 'letBool(${e.name})';
        },
        r'^(int)\??$': (e) {
          return 'letInt(${e.name})';
        },
        r'^(double)\??$': (e) {
          return 'letDouble(${e.name})';
        },
        r'^(num)\??$': (e) {
          return 'letNum(${e.name})';
        },
        r'^(Timestamp)\??$': (e) {
          return '() { final a = ${e.name}; return a is Timestamp ? a: null; }()';
        },
        r'^(DateTime)\??$': (e) {
          return '() { final a = ${e.name}; return a != null ? DateTime.tryParse(a)?.toUtc(): null; }()';
        },
        r'^(Duration)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty?.tryParseDuration()';
        },
        r'^(Uri)\??$': (e) {
          return '(){ final a = ${e.name}; return a is String ? a.trim().nullIfEmpty?.toUriOrNull(): null; }()';
        },
        r'^(Color)\??$': (e) {
          return '(){ final a = letAs<int>(${e.name}); return a is int ? Color(a): null; }()';
        },
        // ---------------------------------------------------------------------
        // Special.
        // ---------------------------------------------------------------------
        r'^(LowerCase-String)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty?.toLowerCase()';
        },
        r'^(Searchable-String)\??$': (e) {
          return "${e.name}?.toString().trim().nullIfEmpty?.toLowerCase().replaceAll(r'[^\\w]', '')";
        },
        r'^(UpperCase-String)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty?.toUpperCase()';
        },
        r'^(LowerSnakeCase-String)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty?.toLowerSnakeCase()';
        },
        r'^(UpperSnakeCase-String)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty?.toUpperSnakeCase()';
        },
        r'^(LowerKebabCase-String)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty?.toLowerKebabCase()';
        },
        r'^(UpperKebabCase-String)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty?.toUpperKebabCase()';
        },
        r'^(LowerDotCase-String)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty?.toLowerDotCase()';
        },
        r'^(UpperDotCase-String)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty?.toUpperDotCase()';
        },
        r'^(CamelCase-String)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty?.toCamelCase()';
        },
        r'^(PascalCase-String)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty?.toPascalCase()';
        },
        r'^(UriPathCase-String)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty?.toUriPathCase()';
        },
        r'^(PathCase-String)\??$': (e) {
          return '${e.name}?.toString().trim().nullIfEmpty?.toPathCase()';
        },
        // ---------------------------------------------------------------------
        // Default.
        // ---------------------------------------------------------------------
        r'^(Type-?\w*|\w*-?Type)\??$': (e) {
          final typeName = e.matchGroups?.elementAt(1);
          return '$typeName.values.valueOf(letAs<String>(${e.name}))';
        },
        r'^(Model-?\w*|\w*-?Model)\??$': (e) {
          final typeName = e.matchGroups?.elementAt(1);
          return '() { final a = letMap<String, dynamic>(${e.name}); return a != null ? $typeName.fromJson(a): null; }()';
        },
        r'^(Enum-?\w*|\w*-?Enum)\??$': (e) {
          final typeName = e.matchGroups?.elementAt(1);
          return '$typeName.values.valueOf(letAs<String>(${e.name}))';
        },
        // ---------------------------------------------------------------------
        // Default.
        // ---------------------------------------------------------------------
        r'^(\w+)\??$': (e) {
          return '${e.name}';
        },
      });

  //
  //
  //

  @override
  get objectToMappers => newTypeMappers<ObjectMapperEvent>({
        // ---------------------------------------------------------------------
        // Standart.
        // ---------------------------------------------------------------------
        r'^(String)\??$': (e) {
          return '${e.name}?.trim().nullIfEmpty';
        },
        r'^(dynamic|bool|int|double|num|Timestamp)\??$': (e) {
          return '${e.name}';
        },
        r'^(DateTime)\??$': (e) {
          return '${e.name}?.toUtc()?.toIso8601String()';
        },
        r'^(Duration|Uri)\??$': (e) {
          return '${e.name}?.toString()';
        },
        r'^(Color)\??$': (e) {
          return '${e.name}?.value';
        },
        // ---------------------------------------------------------------------
        // Special.
        // ---------------------------------------------------------------------
        r'^(LowerCase-String)\??$': (e) {
          return '${e.name}?.trim().nullIfEmpty?.toLowerCase()';
        },
        r'^(Searchable-String)\??$': (e) {
          return "${e.name}?.trim().nullIfEmpty?.toLowerCase().replaceAll(r'[^\\w]', '')";
        },
        r'^(UpperCase-String)\??$': (e) {
          return '${e.name}?.trim().nullIfEmpty?.toUpperCase()';
        },
        r'^(LowerSnakeCase-String)\??$': (e) {
          return '${e.name}?.trim().nullIfEmpty?.toLowerSnakeCase()';
        },
        r'^(UpperSnakeCase-String)\??$': (e) {
          return '${e.name}?.trim().nullIfEmpty?.toUpperSnakeCase()';
        },
        r'^(LowerKebabCase-String)\??$': (e) {
          return '${e.name}?.trim().nullIfEmpty?.toLowerKebabCase()';
        },
        r'^(UpperKebabCase-String)\??$': (e) {
          return '${e.name}?.trim().nullIfEmpty?.toUpperKebabCase()';
        },
        r'^(LowerDotCase-String)\??$': (e) {
          return '${e.name}?.trim().nullIfEmpty?.toLowerDotCase()';
        },
        r'^(UpperDotCase-String)\??$': (e) {
          return '${e.name}?.trim().nullIfEmpty?.toUpperDotCase()';
        },
        r'^(CamelCase-String)\??$': (e) {
          return '${e.name}?.trim().nullIfEmpty?.toCamelCase()';
        },
        r'^(PascalCase-String)\??$': (e) {
          return '${e.name}?.trim().nullIfEmpty?.toPascalCase()';
        },
        r'^(UriPathCase-String)\??$': (e) {
          return '${e.name}?.trim().nullIfEmpty?.toUriPathCase()';
        },
        r'^(PathCase-String)\??$': (e) {
          return '${e.name}?.trim().nullIfEmpty?.toPathCase()';
        },
        r'^(Type-?\w*|\w*-?Type)\??$': (e) {
          return '${e.name}?.name';
        },
        r'^(Model-?\w*|\w*-?Model)\??$': (e) {
          return '${e.name}?.toJson()';
        },
        r'^(Enum-?\w*|\w*-?Enum)\??$': (e) {
          return '${e.name}?.name';
        },
        // ---------------------------------------------------------------------
        // Default.
        // ---------------------------------------------------------------------
        r'^(\w+)\??$': (e) {
          return '${e.name}';
        },
      });
}
