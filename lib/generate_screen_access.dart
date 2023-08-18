// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:xyz_utils/xyz_utils.dart';

import 'utils/file_io.dart';
import 'utils/find_files.dart';
import 'utils/analyze_source_classes.dart';
import 'utils/get_templates_from_md.dart';
import 'utils/helpers.dart';
import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreenAccess(
  String rootDirPath, {
  Set<String> pathPatterns = const {},
  bool deleteGFiles = false,
}) async {
  if (deleteGFiles) {
    await deleteGeneratedFiles(rootDirPath, pathPatterns);
  }
  final templates = await getTemplatesFromMd("./templates/screen_templates.md");
  await findFiles(
    rootDirPath: rootDirPath,
    pathPatterns: pathPatterns,
    onFileFound: (final dirName, final folderName, final filePath) async {
      final (a, _) = isCorrectFileName(filePath, "screen", "dart");
      final b = isSourceDartFilePath(filePath);
      final c = a && b;
      if (c) {
        await _generateForFile(filePath, templates);
      }
    },
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateForFile(
  String fixedFilePath,
  List<String> templates,
) async {
  String? className;
  bool? isOnlyAccessibleIfSignedInAndVerified;
  bool? isOnlyAccessibleIfSignedIn;
  bool? isOnlyAccessibleIfSignedOut;
  bool? isRedirectable;
  Map<String, String>? internalParameters;
  Set<String>? queryParameters;
  List<String>? pathSegments;
  await analyzeAnnotatedClasses(
      filePath: fixedFilePath,
      annotationDisplayName: "GenerateScreenAccess",
      fieldNames: {
        "isOnlyAccessibleIfSignedInAndVerified",
        "isOnlyAccessibleIfSignedIn",
        "isOnlyAccessibleIfSignedOut",
        "isRedirectable",
        "internalParameters",
        "queryParameters",
        "pathSegments",
      },
      onField: (final classDisplayName, final fieldName, final object) {
        className = classDisplayName;
        switch (fieldName) {
          case "isOnlyAccessibleIfSignedInAndVerified":
            isOnlyAccessibleIfSignedInAndVerified = object.toBoolValue();
          case "isOnlyAccessibleIfSignedIn":
            isOnlyAccessibleIfSignedIn = object.toBoolValue();
          case "isOnlyAccessibleIfSignedOut":
            isOnlyAccessibleIfSignedOut = object.toBoolValue();
          case "isRedirectable":
            isRedirectable = object.toBoolValue();
          case "internalParameters":
            internalParameters = object
                .toMapValue()
                ?.map((final k, final v) => MapEntry(k?.toStringValue(), v?.toStringValue()))
                .nonNulls;
          case "queryParameters":
            queryParameters =
                object.toSetValue()?.map((e) => e.toStringValue()).nonNulls.toSet() ?? {};
          case "pathSegments":
            queryParameters =
                object.toListValue()?.map((e) => e.toStringValue()).nonNulls.toSet() ?? {};
            break;
        }
      });

  for (var n = 0; n < templates.length; n++) {
    final template = templates[n];
    final baseName = getBaseName(fixedFilePath);
    final a = getFileNameWithoutExtension(getBaseName(fixedFilePath));
    final b = n == 0 ? "$a.g.dart" : "_${n}_$a.g.dart";
    final c = getDirName(fixedFilePath);
    final d = p.join(c, b);
    final screenKey = className!.toSnakeCase();
    final segment = screenKey.replaceAll("screen_", "");
    final location = "/$segment";
    final segmentKey = segment.toUpperCase();

    final l0 = isOnlyAccessibleIfSignedInAndVerified!;
    final l1 = isOnlyAccessibleIfSignedIn!;
    final l2 = isOnlyAccessibleIfSignedOut!;
    final l3 = isOnlyAccessibleIfSignedInAndVerified! &&
        !isOnlyAccessibleIfSignedIn! &&
        !isOnlyAccessibleIfSignedOut!;
    final l4 = isRedirectable == false;

    final output = replaceAllData(
      template,
      {
        "___CLASS_NAME___": className,
        "___SOURCE_BASE_NAME__": baseName,
        "___SCREEN_KEY___": screenKey,
        "___SEGMENT___": segment,
        "___SEGMENT_KEY___": segmentKey,
        "___LOCATION___": location,
        "__A0__": l0 ? "_LOCATION" : "",
        "__A1__": l1 ? "_LOCATION" : "",
        "__A2__": l2 ? "_LOCATION" : "",
        "__A3__": l3 ? "_LOCATION" : "",
        "__A4__": l4 ? "_LOCATION" : "",
        "___L0___": l0,
        "___L1___": l1,
        "___L2___": l2,
        "___I0___": i0(internalParameters!),
        "___I1___": i1(internalParameters!),
        "___I2___": i2(internalParameters!),
        "___Q0___": q0(queryParameters!),
        "___Q1___": q1(queryParameters!),
        "___Q2___": q2(queryParameters!),
        "___P0___": p0(pathSegments!),
        "___P1___": p1(pathSegments),
        "___P2___": p2(pathSegments),
      }.nonNulls,
    );
    await writeFile(d, output);
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String i0(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((final l) {
    final fieldName = l.key;
    final fieldType = l.value;
    final required = fieldType.endsWith("?") ? "" : "required ";
    return "$required$fieldType $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

String i1(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((final l) {
    final fieldName = l.key;
    final fieldType = l.value;
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
      "$fieldType get $fieldName => super.arguments<$t>($fieldK)$nullCheck;",
    ].join("\n");
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

String i2(Map<String, String> internalParameters) {
  final a = internalParameters.entries.map((final l) {
    final fieldName = l.key;
    final fieldType = l.value;
    final ifNotNull = fieldType.endsWith("?") ? "if ($fieldName != null) " : "";
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return "$ifNotNull $fieldK: $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? "internalParameters: {${a.join("\n")}}" : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String q0(Set<String> queryParameters) {
  final a = queryParameters.map((final l) {
    final fieldName = l;
    final fieldKey = fieldName.toSnakeCase();
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
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

String q1(Set<String> queryParameters) {
  final a = queryParameters.map((final l) {
    final fieldName = l;
    return "String? $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

String q2(Set<String> queryParameters) {
  final a = queryParameters.map((final l) {
    final fieldName = l;
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
    return "if ($fieldName != null) $fieldK: $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? "queryParameters: {${a.join("\n")}}" : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String p0(List<String> pathSegments) {
  var n = 0;
  final a = pathSegments.map((final l) {
    final fieldName = l;
    final fieldK = "K_${fieldName.toSnakeCase().toUpperCase()}";
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

String p1(List<String> pathSegments) {
  final a = pathSegments.map((final l) {
    final fieldName = l;
    return "String? $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join("\n") : "";
}

String p2(List<String> pathSegments) {
  final a = pathSegments.map((final l) {
    final fieldName = l;
    return "$fieldName ?? \"\",";
  }).toList()
    ..sort();
  return a.isNotEmpty ? "pathSegments: [${a.join("\n")}]" : "";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateScreenAccess {
  /// Set to `true` to ensure the screen can only be accessed if the current
  /// user is signed in and verified.
  final bool isOnlyAccessibleIfSignedInAndVerified;

  /// Set to `true` to ensure the screen can only be accessed if the current
  /// user is signed in (and not necessarily verified).
  final bool isOnlyAccessibleIfSignedIn;

  /// Set to `true` to ensure the screen can only be accessed if there are no
  /// currently signed-in users.
  final bool isOnlyAccessibleIfSignedOut;

  /// Set to `false` to ensure that the screen is not redirectable.
  ///
  /// Example:
  ///
  /// If your screen's route is `/delete_account`, normally you can access it
  /// by typing https://medikienct.app/delete_account in the browser. This will
  /// start the app and redirect to "/delete_account". This can be disabled
  /// by setting [isRedirectable] to `false`.
  final bool? isRedirectable;

  /// ...
  final Map<String, String> internalParameters;

  /// ...
  final Set<String> queryParameters;

  /// ...
  final List<String> pathSegments;

  /// Generates boiler-plate code for the annotated screen class to make it
  /// accessible.
  const GenerateScreenAccess({
    this.isOnlyAccessibleIfSignedInAndVerified = false,
    this.isOnlyAccessibleIfSignedIn = false,
    this.isOnlyAccessibleIfSignedOut = false,
    this.isRedirectable,
    this.internalParameters = const {},
    this.queryParameters = const {},
    this.pathSegments = const [],
  });
}
