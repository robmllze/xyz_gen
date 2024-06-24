//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;
import 'package:xyz_utils/xyz_utils.dart';
import 'package:xyz_utils/xyz_utils_non_web.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// An enumeration of languages that are partially or fully supported for code
/// generation.
enum XyzGenLang {
  //
  //
  //

  DART(langCode: 'dart'),
  TYPESCRIPT(langCode: 'ts');

  //
  //
  //

  /// The language code used to identify the language, derived by converting
  /// the common file extension associated with the language to lowercase.
  final String langCode;

  //
  //
  //

  const XyzGenLang({
    required this.langCode,
  });

  //
  //
  //

  /// The file extension associated with the language, e.g. '.dart'.
  String get srcExt => '.${this.langCode}';

  /// The generated file extension associated with the language, e.g. '.g.dart'.
  String get genExt => '.g.${this.langCode}';

  /// Whether [filePath] is a valid file path for the language.
  bool isValidFilePath(String filePath) {
    return filePath.toLowerCase().endsWith(this.srcExt);
  }

  /// Whether [filePath] is a valid generated file path for the language.
  bool isValidGenFilePath(String filePath) {
    return filePath.toLowerCase().endsWith(this.genExt);
  }

  /// Whether [filePath] is a valid source file path for the language, i.e.
  /// a valid file path that is not a generated file path.
  bool isValidSrcFilePath(String filePath) {
    return this.isValidFilePath(filePath) && !this.isValidGenFilePath(filePath);
  }

  /// Returns corresponding source file path for [filePath] or `null` if the
  /// [filePath] is invalid for this language.
  ///
  /// **Example for XyzGenLang.DART:**
  /// ```txt
  /// 'hello.dart' returns 'hello.dart'
  /// 'hello.g.dart' returns 'hello.dart'
  /// 'hello.world' returns null, since 'world' is not valid for XyzGenLang.DART.
  /// ```
  String? getCorrespondingSrcPathOrNull(String filePath) {
    final localSystemFilePath = toLocalSystemPathFormat(filePath);
    final dirName = p.dirname(localSystemFilePath);
    final baseName = p.basename(localSystemFilePath);
    final valid = this.isValidGenFilePath(localSystemFilePath);
    if (valid) {
      final baseNameNoExt = baseName.substring(0, baseName.length - this.genExt.length);
      final srcBaseName = '$baseNameNoExt${this.srcExt}';
      final result = p.join(dirName, srcBaseName);
      return result;
    }
    if (baseName.endsWith(this.srcExt)) {
      return localSystemFilePath;
    }
    return null;
  }

  /// Returns corresponding generated file path for [filePath] or `null` if
  /// [filePath] is invalid for this language.
  ///
  /// **Example for XyzGenLang.DART:**
  /// ```txt
  /// 'hello.g.dart' returns 'hello.g.dart'
  /// 'hello.dart' returns 'hello.g.dart'
  /// 'hello.g.world' returns null, since 'world' is not valid for XyzGenLang.DART.
  /// ```
  String? getCorrespondingGenPathOrNull(String filePath) {
    final localSystemFilePath = toLocalSystemPathFormat(filePath);
    final dirName = p.dirname(localSystemFilePath);
    final baseName = p.basename(localSystemFilePath);
    final valid = this.isValidSrcFilePath(localSystemFilePath);
    if (valid) {
      final baseNameNoExt = baseName.substring(0, baseName.length - this.srcExt.length);
      final srcBaseName = '$baseNameNoExt${this.srcExt}';
      final result = p.join(dirName, srcBaseName);
      return result;
    }
    if (baseName.endsWith(this.srcExt)) {
      return localSystemFilePath;
    }
    return null;
  }

  /// Whether the source-and-generated pair exists for the file at [filePath]
  /// or not.
  ///
  /// This means, if [filePath] exists and points to a source file, it also
  /// checks if its generated file exists at the same location. The reverse
  /// also holds true.
  Future<bool> srcAndGenPairExistsFor(String filePath) async {
    final a = await fileExists(filePath);
    if (!a) {
      return false;
    }
    if (this.isValidSrcFilePath(filePath)) {
      final b = await fileExists(
        '${filePath.substring(0, filePath.length - this.srcExt.length)}${this.genExt}',
      );
      return b;
    } else if (this.isValidGenFilePath(filePath)) {
      final b = await fileExists(
        '${filePath.substring(0, filePath.length - this.genExt.length)}${this.srcExt}',
      );
      return b;
    } else {
      return false;
    }
  }

  /// Deletes the source file corresponding to [filePath] if it exists.
  ///
  /// Returns `true` if the file was successfully deleted, otherwise returns
  /// `false`.
  Future<bool> deleteSrcFile(String filePath) async {
    final genFilePath = getCorrespondingSrcPathOrNull(filePath);
    if (genFilePath != null) {
      try {
        await deleteFile(genFilePath);
        return true;
      } catch (_) {}
    }
    return false;
  }

  /// Deletes the generated file corresponding to  [filePath] if it exists.
  ///
  /// Returns `true` if the file was successfully deleted, otherwise returns
  /// `false`.
  Future<bool> deleteGenFile(String filePath) async {
    final genFilePath = getCorrespondingGenPathOrNull(filePath);
    if (genFilePath != null) {
      try {
        await deleteFile(genFilePath);
        return true;
      } catch (_) {}
    }
    return false;
  }

  sadasas() {}
}
