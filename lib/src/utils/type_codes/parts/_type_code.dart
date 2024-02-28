//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
// 
// X|Y|Z Gen
//
// https://xyzand.dev/
//
// See LICENSE file in the root of this project for license details.
// 
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of '../type_codes.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class TypeCode {
  //
  //
  //

  final String value;

  //
  //
  //

  const TypeCode(this.value);

  //
  //
  //

  static bool isNullable(String value) {
    return value.endsWith("?") || value == "dynamic";
  }

  //
  //
  //

  bool get nullable => isNullable(this.getName());

  //
  //
  //

  String getName() => _typeCodeToName(this.value);

  //
  //
  //

  String get nullableName {
    final name = this.getName();
    return isNullable(name) ? name : "$name?";
  }

  //
  //
  //

  static String _typeCodeToName(String value) {
    var temp = value.replaceAll(" ", "");
    temp = temp.split("-").last;
    temp = temp.replaceAll("|let", "");
    while (true) {
      final match = RegExp(r"\w+\|clean\<([\w\[\]\+]+\??)(,[\w\[\]\+]+\??)*\>")
          .firstMatch(temp);
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
    return temp.replaceAll("[", "<").replaceAll("]", ">").replaceAll("+", ", ");
  }

  //
  //
  //

  @override
  int get hashCode => this.value.hashCode;

  //
  //
  //

  @override
  bool operator ==(Object other) {
    return other.runtimeType == TypeCode && other.hashCode == this.hashCode;
  }
}