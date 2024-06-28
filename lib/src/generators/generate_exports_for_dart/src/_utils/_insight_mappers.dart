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
    mapInsights: (insight) async {
      final dir = insight.dir;
      final filePaths = dir.files.map((e) => p.relative(e.path, from: dir.path));
      final exportFilePaths = filePaths.where((e) {
        final baseName = p.basename(e);
        return baseName.endsWith('.dart') && !baseName.endsWith('.g.dart');
      });
      if (exportFilePaths.isNotEmpty) {
        final statements = exportFilePaths.map((e) => "export '$e';");
        return statements.join('\n');
      } else {
        return '// ---';
      }
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.PRIVATE_EXPORTS,
    mapInsights: (e) async {
      return '// ---';
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.GENERATED_EXPORTS,
    mapInsights: (e) async {
      return '// ---';
    },
  ),
];

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum Placeholders {
  PUBLIC_EXPORTS,
  PRIVATE_EXPORTS,
  GENERATED_EXPORTS,
}

typedef _InsightMapper = xyz.InsightMapper<xyz.DirInsight, Placeholders>;

typedef GeneratorConverger = xyz.GeneratorConverger<_InsightMapper, Placeholders>;
