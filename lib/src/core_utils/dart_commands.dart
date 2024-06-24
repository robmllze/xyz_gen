//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:io';

import 'package:xyz_utils/xyz_utils_non_web.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Formats the Dart file at [filePath] via the `dart format` command
Future<void> fmtDartFile(String filePath) async {
  try {
    final localFilePath = toLocalSystemPathFormat(filePath);
    await Process.run('dart', ['format', localFilePath]);
  } catch (_) {
    Here().debugLogError('Error formatting Dart file at $filePath');
  }
}

/// Fixes the Dart file at [filePath] via `dart fix --apply` command.
Future<void> fixDartFile(String filePath) async {
  try {
    final localFilePath = toLocalSystemPathFormat(filePath);
    await Process.run('dart', ['fix', '--apply', localFilePath]);
  } catch (_) {
    Here().debugLogError('Error fixing Dart file at $filePath');
  }
}
