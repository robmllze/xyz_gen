// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of '../generate_screen_configurations.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ip0(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((final l) {
    final fieldName = l.key;
    final fieldType = l.value;
    final fieldKey = fieldName.toSnakeCase();
    final nullable = fieldType.endsWith("?");
    final nullCheck = nullable ? "" : "!";
    final t = nullable ? fieldType.substring(0, fieldType.length - 1) : fieldType;
    final fieldK = "_K_${fieldName.toSnakeCase().toUpperCase()}";
    return [
      "/// Key corresponding to the value `$fieldName`",
      "static const $fieldK = \"$fieldKey\";",
      "/// Returns the **internal parameter** with the key `$fieldKey`",
      "/// or [$fieldK].",
      "$fieldType get $fieldName => super.arguments<$t>($fieldK)$nullCheck;",
    ].join("\n");
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ip1(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((final l) {
    final fieldName = l.key;
    final fieldType = l.value;
    final required = fieldType.endsWith("?") ? "" : "required ";
    return "$required$fieldType $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ip2(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((final l) {
    final fieldName = l.key;
    final fieldType = l.value;
    final ifNotNull = fieldType.endsWith("?") ? "if ($fieldName != null) " : "";
    final fieldK = "_K_${fieldName.toSnakeCase().toUpperCase()}";
    return "$ifNotNull $fieldK: $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? "internalParameters: {${a.join("\n")}}," : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _qp0(Set<String> queryParameters) {
  final a = queryParameters.map((final l) {
    final fieldName = l;
    final fieldKey = fieldName.toSnakeCase();
    final fieldK = "_K_${fieldName.toSnakeCase().toUpperCase()}";
    return [
      "/// Key corresponding to the value `$fieldName`",
      "static const $fieldK = \"$fieldKey\";",
      "/// Returns the URI **query parameter** with the key `$fieldKey`",
      "/// or [$fieldK].",
      "String? get $fieldName => super.arguments<String>($fieldK);",
    ].join("\n");
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _qp1(Set<String> queryParameters) {
  final a = queryParameters.map((final l) {
    final fieldName = l;
    return "String? $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _qp2(Set<String> queryParameters) {
  final a = queryParameters.map((final l) {
    final fieldName = l;
    final fieldK = "_K_${fieldName.toSnakeCase().toUpperCase()}";
    return "if ($fieldName != null) $fieldK: $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? "queryParameters: {${a.join("\n")}}," : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ps0(List<String> pathSegments) {
  var n = 0;
  final a = pathSegments.map((final l) {
    final fieldName = l;
    final fieldK = "_K_${fieldName.toSnakeCase().toUpperCase()}";
    return [
      "/// Key corresponding to the value `$fieldName`",
      "static const $fieldK = ${++n};",
      "/// Returns the URI **path segment** at position `$n` AKA the value",
      "/// corresponding to the key `$n` or [$fieldK].",
      "String? get $fieldName => super.arguments<String>($fieldK)?.nullIfEmpty;",
    ].join("\n");
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ps1(List<String> pathSegments) {
  final a = pathSegments.map((final l) {
    final fieldName = l;
    return "String? $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ps2(List<String> pathSegments) {
  final a = pathSegments.map((final l) {
    final fieldName = l;
    return "$fieldName ?? \"\",";
  }).toList()
    ..sort();
  return a.isNotEmpty ? "pathSegments: [${a.join("\n")}]," : "";
}
