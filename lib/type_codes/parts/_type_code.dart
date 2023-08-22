// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of '../type_codes.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class TypeCode {
  //
  //
  //

  final String typeCode;

  //
  //
  //

  const TypeCode(this.typeCode);

  //
  //
  //

  bool nullable() {
    final name = this.getName();
    return name.endsWith("?") || name == "dynamic";
  }

  //
  //
  //

  String getName() => _typeCodeToName(typeCode);

  //
  //
  //

  String getNullableName() => this.nullable() ? this.getName() : "${this.getName()}?";

  //
  //
  //

  static String _typeCodeToName(String typeCode) {
    var temp = typeCode //
        .replaceAll(" ", "")
        .replaceAll("|let", "");
    while (true) {
      final match = RegExp(r"\w+\|clean\<([\w\[\]\+]+\??)(,[\w\[\]\+]+\??)*\>").firstMatch(temp);
      if (match == null) break;
      final group0 = match.group(0);
      if (group0 == null) break;
      temp = temp.replaceAll(
        group0,
        group0
            .replaceAll("|clean", "")
            .replaceAll("?", "")
            .replaceAll("<", "[")
            .replaceAll(">", "]")
            .replaceAll(",", "+"),
      );
    }
    return temp //
        .replaceAll("[", "<")
        .replaceAll("]", ">")
        .replaceAll("+", ", ");
  }

  //
  //
  //

  @override
  int get hashCode => this.typeCode.hashCode;

  //
  //
  //

  @override
  bool operator ==(Object other) {
    return other.runtimeType == TypeCode && other.hashCode == this.hashCode;
  }
}
