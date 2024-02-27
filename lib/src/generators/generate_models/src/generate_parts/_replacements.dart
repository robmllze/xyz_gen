//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of '../generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Map<String, String> _replacements({
  required Map<String, TypeCode> fields,
  required StringCaseType keyStringCaseType,
  required bool includeId,
  required bool includeArgs,
}) {
  final camelCaseFields = fields.map((k, v) => MapEntry(k.toCamelCase(), v));
  final id = includeId ? camelCaseFields["id"] ??= const TypeCode("String?") : null;
  final args = includeArgs ? camelCaseFields["args"] ??= const TypeCode("dynamic") : null;
  final allEntries = camelCaseFields.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  final allIds = allEntries.map((e) => e.key);
  final ids = allIds.where((e) => !const ["id", "args"].contains(e));
  final entries = ids.map((i) => MapEntry(i, camelCaseFields[i]));
  final nonNullableIds = allIds.where((e) => !camelCaseFields[e]!.nullable);
  final allKeys = _getKeyNames(allIds, keyStringCaseType);
  final allKeyConsts = _getKeyConstNames(allIds);

  final p = <Iterable>[
    // ___P0___
    allIds.map((e) => 'static const ${allKeyConsts[e]} = "${allKeys[e]}";'),
    // ___P1___
    entries.map((e) => "${e.value!.nullableName} ${e.key};"),
    // ___P2___
    [
      if (id != null)
        () {
          assert(id.nullableName == "String?");
          return "${id.nullable ? "" : "required "}${id.getName()} id,";
        }(),
      if (args != null)
        () {
          return "${args.nullable ? "" : "required "}${args.getName()} args,";
        }(),
      ...entries.map((e) => "${e.value!.nullable ? "" : "required "}this.${e.key},"),
    ],
    // ___P3___
    [
      if (id != null) "this.id = id;",
      if (args != null) "this.args = args;",
    ],
    // ___P4___
    [
      if (id != null) "String? id,",
      if (args != null) "${args.nullableName} args,",
      ...ids.map((e) => "this.$e,"),
    ],
    // ___P5___
    nonNullableIds.map((e) => "assert(this.$e != null);"),
    // ___P6___
    allIds.map((e) {
      final fieldName = "data[${allKeyConsts[e]}]";
      final parameter = camelCaseFields[e]!;
      final typeCode = parameter.value;
      final value = mapWithFromMappers(
        typeMappers: LooseTypeMappers.instance,
        fieldName: fieldName,
        typeCode: typeCode,
      );
      return "$e: $value,";
    }),

    // ___P7___
    allIds.map((e) {
      final keyConst = allKeyConsts[e];
      final parameter = camelCaseFields[e]!;
      final typeCode = parameter.value;
      final value = mapWithToMappers(
        typeMappers: LooseTypeMappers.instance,
        fieldName: e,
        typeCode: typeCode,
      );
      return "$keyConst: $value,";
    }),
    // ___P8___
    allIds.map((e) {
      final keyConst = allKeyConsts[e];
      return "this.$e = data[$keyConst] ?? this.$e;";
    }),
  ];

  final output = <String, String>{};
  for (var n = 0; n < p.length; n++) {
    output["___P${n}___"] = p[n].join("\n");
  }
  return output;
}
