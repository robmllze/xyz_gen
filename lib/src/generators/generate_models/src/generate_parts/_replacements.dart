//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of '../generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Map<String, String> _replacements(
  Map<String, TypeCode> input,
  StringCaseType keyStringCaseType,
) {
  final fields = input.map((k, v) => MapEntry(k.toCamelCase(), v));
  final id = fields["id"] ??= const TypeCode("String?");
  final args = fields["args"] ??= const TypeCode("dynamic");
  final allEntries = fields.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  final allIds = allEntries.map((e) => e.key);
  final ids = allIds.where((e) => !const ["id", "args"].contains(e));
  final entries = ids.map((i) => MapEntry(i, fields[i]));
  final nonNullableIds = allIds.where((e) => !fields[e]!.nullable);
  final allKeys = _getKeyNames(allIds, keyStringCaseType);
  final allKeyConsts = _getKeyConstNames(allIds);

  final p = <Iterable>[
    // ___P0___
    allIds.map((e) => 'static const ${allKeyConsts[e]} = "${allKeys[e]}";'),
    // ___P1___
    entries.map((e) => "${e.value!.nullableName} ${e.key};"),
    // ___P2___
    [
      () {
        assert(id.nullableName == "String?");
        return "${id.nullable ? "" : "required "}${id.getName()} id,";
      }(),
      "${args.nullable ? "" : "required "}${args.getName()} args,",
      ...entries.map((e) => "${e.value!.nullable ? "" : "required "}this.${e.key},"),
    ],
    // ___P3___
    [
      "this.id = id;",
      "this.args = args;",
    ],
    // ___P4___
    [
      "String? id,",
      "${args.nullableName} args,",
      ...ids.map((e) => "this.$e,"),
    ],
    // ___P5___
    nonNullableIds.map((e) => "assert(this.$e != null);"),
    // ___P6___
    allIds.map((e) {
      final fieldName = "input[${allKeyConsts[e]}]";
      final parameter = fields[e]!;
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
      final parameter = fields[e]!;
      final typeCode = parameter.value;
      final value = mapWithToMappers(
        typeMappers: LooseTypeMappers.instance,
        fieldName: e,
        typeCode: typeCode,
      );
      return "$keyConst: $value,";
    }),
    // ___P8___
    allIds.map((e) => "this.$e = other.$e ?? this.$e;"),
  ];

  final output = <String, String>{};
  for (var n = 0; n < p.length; n++) {
    output["___P${n}___"] = p[n].join("\n");
  }
  return output;
}
