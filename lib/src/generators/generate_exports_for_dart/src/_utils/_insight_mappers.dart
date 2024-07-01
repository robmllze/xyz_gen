//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;

import '/src/xyz/_all_xyz.g.dart' as xyz;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final insightMappers = [
  _InsightMapper(
    placeholder: Placeholders.PUBLIC_EXPORTS,
    mapInsights: (insight) async => _mapper(
      insight,
      (e) => e.endsWith('.dart') && !e.endsWith('.g.dart'),
      (e) => "export '$e';",
    ),
  ),
  _InsightMapper(
    placeholder: Placeholders.PRIVATE_EXPORTS,
    mapInsights: (insight) async => _mapper(
      insight,
      (e) => e.startsWith('_') && !e.endsWith('.g.dart'),
      (e) => "// export '$e';",
    ),
  ),
  _InsightMapper(
    placeholder: Placeholders.GENERATED_EXPORTS,
    mapInsights: (insight) async => _mapper(
      insight,
      (e) => e.endsWith('.g.dart'),
      (e) => "// export '$e';",
    ),
  ),
];

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _mapper(
  xyz.DirInsight insight,
  bool Function(String) test,
  String Function(String) statementBuilder,
) {
  final dir = insight.dir;
  final filePaths = dir.files.map((e) => p.relative(e.path, from: dir.path));
  final exportFilePaths = filePaths.where((e) => test(p.basename(e)));
  if (exportFilePaths.isNotEmpty) {
    final statements = exportFilePaths.map(statementBuilder);
    return statements.join('\n');
  } else {
    return '// None found.';
  }
}

enum Placeholders {
  PUBLIC_EXPORTS,
  PRIVATE_EXPORTS,
  GENERATED_EXPORTS,
}

typedef _InsightMapper = xyz.InsightMapper<xyz.DirInsight, Placeholders>;

typedef GeneratorConverger = xyz.GeneratorConverger<_InsightMapper, Placeholders>;
