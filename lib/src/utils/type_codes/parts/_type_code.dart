//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of '../type_codes.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class TypeCode {
  //
  //
  //

  final String code;

  //
  //
  //

  const TypeCode(this.code);

  //
  //
  //

  factory TypeCode.b(
    String code, {
    bool? nullable,
  }) {
    return nullable == null
        ? TypeCode(code)
        : nullable
            ? TypeCode(
                code.endsWith('?') ? code : '$code?',
              )
            : TypeCode(
                code.endsWith('?') ? code.substring(0, code.length - 1) : code,
              );
  }

  //
  //
  //

  static bool isNullable(String value) {
    return value.endsWith('?') || value == 'dynamic';
  }

  //
  //
  //

  bool get nullable => isNullable(this.name);

  //
  //
  //

  String get name => _typeCodeToName(this.code);

  //
  //
  //

  String get nullableName {
    final a = this.name;
    return isNullable(a) ? a : '$a?';
  }

  //
  //
  //

  String get nonNullableName {
    final a = this.name;
    return isNullable(a) ? a.substring(0, a.length - 1) : a;
  }

  //
  //
  //

  static String _typeCodeToName(String input) {
    String step0(String input) {
      return input.replaceAll(' ', '');
    }

    String step1(String input) {
      return input.replaceAll('|let', '');
    }

    String step2(String input) {
      return input.replaceAllMapped(
        RegExp(r'(\b\w+-)*(\w+)\b'),
        (m) => m.group(2)!,
      );
    }

    String step3(String input) {
      final x = RegExp(r'\w+\|clean\<([\w\[\]\+]+\??)(,[\w\[\]\+]+\??)*\>');
      var output = input;
      while (true) {
        final group0 = x.firstMatch(output)?.group(0);
        if (group0 == null) break;
        final replacement = group0
            .replaceAll('|clean', '')
            .replaceAll('?', '')
            .replaceAll('<', '[')
            .replaceAll('>', ']')
            .replaceAll(',', '+');
        output = output.replaceAll(group0, replacement);
      }
      return output;
    }

    String step4(String input) {
      return input.replaceAll('[', '<').replaceAll(']', '>').replaceAll('+', ', ');
    }

    var output = input;
    output = step0(input);
    output = step1(output);
    output = step2(output);
    output = step3(output);
    output = step4(output);
    return output;
  }

  //
  //
  //

  String toTypescriptTypeString() {
    const typeMapping = {
      'int': 'number',
      'double': 'number',
      'num': 'number',
      'String': 'string',
      'bool': 'boolean',
      'List': 'Array',
      'Map': 'Map',
      'Set': 'Set',
      'DateTime': 'Date',
      'Duration': 'number',
      'dynamic': 'any',
      'void': 'void',
    };
    var type = typeMapping[this.nonNullableName] ?? 'any';
    if (this.nullable && type != 'any' && type != 'void') {
      type += ' | null';
    }
    return type;
  }

  //
  //
  //

  @override
  int get hashCode => this.code.hashCode;

  //
  //
  //

  @override
  bool operator ==(Object other) {
    return other.runtimeType == TypeCode && other.hashCode == this.hashCode;
  }

  //
  //
  //

  @override
  String toString() => this.code;
}
