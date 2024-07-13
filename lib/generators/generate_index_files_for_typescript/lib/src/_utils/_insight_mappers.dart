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

import '/src/xyz/_index.g.dart' as xyz;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final insightMappers = [
  _InsightMapper(
    placeholder: Placeholders.PUBLIC_EXPORTS,
    mapInsights: (insight) async => _mapper(
      insight,
      (e) {
        return !e.contains('${p.separator}_') && !e.endsWith('.g.ts') && e.endsWith('.ts');
      },
      (e) => "export * from './$e';",
    ),
  ),
  _InsightMapper(
    placeholder: Placeholders.PRIVATE_EXPORTS,
    mapInsights: (insight) async => _mapper(
      insight,
      (e) => e.contains('${p.separator}_') && !e.endsWith('.g.ts'),
      (e) => "// export * from './$e';",
    ),
  ),
  _InsightMapper(
    placeholder: Placeholders.GENERATED_EXPORTS,
    mapInsights: (insight) async => _mapper(
      insight,
      (e) => !e.contains('${p.separator}_') && e.endsWith('.g.ts'),
      (e) => "// export * from './$e';",
    ),
  ),
];

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _mapper(
  xyz.DirInsight insight,
  bool Function(String filePath) test,
  String Function(String baseName) statementBuilder,
) {
  final dir = insight.dir;
  final filePaths = dir.getSubFiles().map((e) => p.relative(e.path, from: dir.path));
  final exportFilePaths = filePaths.where((e) => test(e));
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
