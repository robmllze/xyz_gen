// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of '../generate_model.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Map<String, String> _replacements(Map<String, TypeCode> input) {
  final parameters = Map<String, TypeCode>.from(input);

  final id = parameters["id"] ??= const TypeCode("String?");
  final args = parameters["args"] ??= const TypeCode("dynamic");
  final allEntries = parameters.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  final allIds = allEntries.map((e) => e.key);
  final ids = allIds.where((e) => !const ["id", "args"].contains(e));
  final entries = ids.map((i) => MapEntry(i, parameters[i]));
  final nonNullableIds = allIds.where((e) => !parameters[e]!.nullable());
  final keys = _getKeyNames(allIds);
  final keyConsts = _getKeyConstNames(allIds);

  final p = <Iterable>[
    // ___P0___
    allIds.map((e) => 'static const ${keyConsts[e]} = "${keys[e]}";'),
    // ___P1___
    entries.map((e) => "${e.value!.getNullableName()} ${e.key};"),
    // ___P2___
    [
      () {
        assert(id.getNullableName() == "String?");
        return id.nullable() ? "String? id" : "required String id,";
      }(),
      "${args.nullable() ? "" : "required "}${args.getName()} args,",
      ...entries.map((e) => "${e.value!.nullable() ? "" : "required "}this.${e.key},"),
    ],
    // ___P3___
    ["this.id = id;", "this.args = args;"],
    // ___P4___
    [
      "String? id,",
      "${args.getNullableName()} args,",
      ...ids.map((e) => "this.$e,"),
    ],
    // ___P5___
    nonNullableIds.map((e) => "assert(this.$e != null);"),
    // ___P6___
    allIds.map((e) {
      final fieldName = "input[${keyConsts[e]}]";
      final parameter = parameters[e]!;
      final typeCode = parameter.typeCode;
      final value = mapWithLooseFromMappers(
        fieldName: fieldName,
        typeCode: typeCode,
      );
      return "$e: $value,";
    }),

    // ___P7___
    allIds.map((e) {
      final keyConst = keyConsts[e];
      final parameter = parameters[e]!;
      final typeCode = parameter.typeCode;
      final value = mapWithLooseToMappers(
        fieldName: e,
        typeCode: typeCode,
      );
      return "$keyConst: $value,";
    }),
    // 8
    allIds.map((e) => 'this.$e = other.$e ?? this.$e;'),
  ];

  final output = <String, String>{};
  for (var n = 0; n < p.length; n++) {
    output["___P${n}___"] = p[n].join("\n");
  }
  return output;
}
