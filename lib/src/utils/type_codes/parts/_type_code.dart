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

  final String value;

  //
  //
  //

  const TypeCode(this.value);

  //
  //
  //

  static bool isNullable(String value) {
    return value.endsWith('?') || value == 'dynamic';
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
    return isNullable(name) ? name : '$name?';
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
