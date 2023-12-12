//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of '../generate_screen_configurations.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ip0(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((e) {
    final fieldName = e.key;
    final fieldType = e.value;
    final fieldKey = fieldName.toSnakeCase();
    final nullable = fieldType.endsWith("?");
    final nullCheck = nullable ? "" : "!";
    final t = nullable ? fieldType.substring(0, fieldType.length - 1) : fieldType;
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return [
      "/// Key corresponding to the value `$fieldName`",
      "static const $fieldK = \"$fieldKey\";",
      "/// Returns the **internal parameter** with the key `$fieldKey`",
      "/// or [$fieldK].",
      "$fieldType get $fieldName => super.arg<$t>($fieldK)$nullCheck;",
    ].join("\n");
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ip1(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((e) {
    final fieldName = e.key;
    final fieldType = e.value;
    final required = fieldType.endsWith("?") ? "" : "required ";
    return "$required$fieldType $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ip3(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((e) {
    final fieldName = e.key;
    final fieldType = e.value;
    final ifNotNull = fieldType.endsWith("?") ? "if ($fieldName != null) " : "";
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return "$ifNotNull $fieldK: $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _qp0(Set<String> queryParameters) {
  final a = queryParameters.map((e) {
    var fieldName = e;
    final nullable = fieldName.endsWith("?");
    fieldName = nullable ? fieldName.substring(0, fieldName.length - 1) : fieldName;
    final fieldKey = fieldName.toSnakeCase();
    final nullCheck = nullable ? "" : "!";
    final nullableCheck = nullable ? "?" : "";
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return [
      "/// Key corresponding to the value `$fieldName`",
      "static const $fieldK = \"$fieldKey\";",
      "/// Returns the URI **query parameter** with the key `$fieldKey`",
      "/// or [$fieldK].",
      "String$nullableCheck get $fieldName => super.arg<String>($fieldK)$nullCheck;",
    ].join("\n");
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _qp1(Set<String> queryParameters) {
  return _ps1(queryParameters.toList());
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _qp3(Set<String> queryParameters) {
  return _ps3(queryParameters.toList());
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ps0(List<String> pathSegments) {
  var n = 0;
  final a = pathSegments.map((e) {
    var fieldName = e;
    final nullable = fieldName.endsWith("?");
    fieldName = nullable ? fieldName.substring(0, fieldName.length - 1) : fieldName;
    final nullCheck = nullable ? "" : "!";
    final nullableCheck = nullable ? "?" : "";
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return [
      "/// Key corresponding to the value `$fieldName`",
      "static const $fieldK = ${++n};",
      "/// Returns the URI **path segment** at position `$n` AKA the value",
      "/// corresponding to the key `$n` or [$fieldK].",
      "String$nullableCheck get $fieldName => super.arg<String>($fieldK)$nullCheck;",
    ].join("\n");
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ps1(List<String> pathSegments) {
  final a = pathSegments.map((e) {
    var fieldName = e;
    final nullable = fieldName.endsWith("?");
    fieldName = nullable ? fieldName.substring(0, fieldName.length - 1) : fieldName;
    return "${nullable ? "String?" : "required String"} $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _ps3(List<String> pathSegments) {
  final a = pathSegments.map((e) {
    var fieldName = e;
    final nullable = fieldName.endsWith("?");
    fieldName = nullable ? fieldName.substring(0, fieldName.length - 1) : fieldName;
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return "${nullable ? "if ($fieldName != null) " : ""}$fieldK: $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}
