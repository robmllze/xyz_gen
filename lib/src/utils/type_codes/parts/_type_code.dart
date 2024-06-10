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

abstract class _TypeCode {
  final String code;

  const _TypeCode(this.code);

  String get name;
  bool get nullable;

  String get nullableName;

  String get nonNullableName;

  @override
  int get hashCode => this.code.hashCode;

  @override
  bool operator ==(Object other) {
    return other.runtimeType == _TypeCode && other.hashCode == this.hashCode;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class DartTypeCode extends _TypeCode {
  const DartTypeCode(super.code);

  factory DartTypeCode.b(
    String code, {
    bool? nullable,
  }) {
    return nullable == null
        ? DartTypeCode(code)
        : nullable
            ? DartTypeCode(
                code.endsWith('?') ? code : '$code?',
              )
            : DartTypeCode(
                code.endsWith('?') ? code.substring(0, code.length - 1) : code,
              );
  }

  TypeScriptTypeCode toTypeScriptTypeCode() {
    return TypeScriptTypeCode.b(this.nonNullableName, nullable: this.nullable);
  }

  @override
  String get name => _typeCodeToNameDart(this.code);

  @override
  bool get nullable => this.name.endsWith('?') || this.name == 'dynamic';

  @override
  String get nullableName => this.nullable ? this.name : '${this.name}?';

  @override
  String get nonNullableName =>
      this.nullable ? this.name.substring(0, this.name.length - '?'.length) : this.name;

  String? toTypeScriptTypeString() {
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

    // Retrieve the TypeScript type from the mapping or return null if not found
    var type = typeMapping[this.nonNullableName];
    if (type == null) {
      return null;
    }

    // Append '|null' if the property is nullable and the type isn't 'any' or 'void'
    if (this.nullable && type != 'any' && type != 'void') {
      type += '|null';
    }

    return type;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class TypeScriptTypeCode extends _TypeCode {
  const TypeScriptTypeCode(super.code);

  factory TypeScriptTypeCode.b(
    String code, {
    bool? nullable,
  }) {
    return nullable == null
        ? TypeScriptTypeCode(code)
        : nullable
            ? TypeScriptTypeCode(
                code.endsWith('|null') ? code : '$code|null',
              )
            : TypeScriptTypeCode(
                code.endsWith('|null') ? code.substring(0, code.length - '|null'.length) : code,
              );
  }

  DartTypeCode toDartTypeCode() {
    return DartTypeCode.b(this.nonNullableName, nullable: this.nullable);
  }

  @override
  String get name => this.code;

  @override
  bool get nullable =>
      this.name == 'any' ||
      this.name == 'unknown' ||
      this.name == 'void' ||
      this.name.endsWith('|null');

  @override
  String get nullableName => this.nullable ? this.name : '${this.name}|null';

  @override
  String get nonNullableName =>
      this.nullable ? this.name.substring(0, this.name.length - '|null'.length) : this.name;

  String? toDartTypeString() {
    const typeMapping = {
      'number': 'num',
      'string': 'String',
      'boolean': 'bool',
      'Array': 'List',
      'Map': 'Map',
      'Set': 'Set',
      'Date': 'DateTime',
      'any': 'dynamic',
      'void': 'void',
    };

    // Retrieve the Dart type from the mapping or return null if not found
    var type = typeMapping[this.nonNullableName];
    if (type == null) {
      return null;
    }

    // Append '?' if the property is nullable and the type isn't 'dynamic' or 'void'
    if (this.nullable && type != 'dynamic' && type != 'void') {
      type += '?';
    }

    return type;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _typeCodeToNameDart(String input) {
  // Step 0: Remove all spaces from the input string.
  String $step0(String input) {
    return input.replaceAll(' ', '');
  }

  // Step 1: Remove the '@let' substring from the input string.
  String $step1(String input) {
    return input.replaceAll('@let', '');
  }

  // Step 2: Simplify expressions by retaining only the last word in sequences
  // that may include hyphen-separated prefixes.
  // Example: "LowerCase-String" becomes "String".
  String $step2(String input) {
    return input.replaceAllMapped(
      RegExp(r'(\b\w+-)*(\w+)\b'),
      (m) => m.group(2)!,
    );
  }

  // Step 3: Transform a specialized 'clean' format into a bracketed list format.
  // This changes annotations such as "Type@clean<SubType, AnotherType>" to
  // "Type[SubType, AnotherType]" for standardization.
  String $step3(String input) {
    final x = RegExp(r'\w+\@clean\<([\w\[\]\+]+\??)(,[\w\[\]\+]+\??)*\>');
    var output = input;
    while (true) {
      final group0 = x.firstMatch(output)?.group(0);
      if (group0 == null) break;
      final replacement = group0
          .replaceAll('@clean', '')
          .replaceAll('?', '')
          .replaceAll('<', '[')
          .replaceAll('>', ']')
          .replaceAll(',', '+');
      output = output.replaceAll(group0, replacement);
    }
    return output;
  }

  // Step 4: Reverse some transformations made in Step 3, converting
  // brackets back to angle brackets and pluses back to commas.
  // This is likely to restore generic type syntax closer to standard Dart or TypeScript formats.
  String step4(String input) {
    return input.replaceAll('[', '<').replaceAll(']', '>').replaceAll('+', ', ');
  }

  // Apply all transformations sequentially to the input string.
  var output = input;
  output = $step0(input);
  output = $step1(output);
  output = $step2(output);
  output = $step3(output);
  output = step4(output);
  return output;
}
