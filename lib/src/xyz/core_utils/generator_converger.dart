//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/src/xyz/_all_xyz.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GeneratorConverger<TInsight extends Insight, TPlaceholder extends Enum> {
  //
  //
  //

  final Future<void> Function(
    Iterable<Replacements<TInsight>> insights,
    List<FileReadResult> templates,
  ) _converge;

  //
  //
  //

  const GeneratorConverger(this._converge);

  //
  //
  //

  Future<void> Function(
    Iterable<TInsight> insights,
    List<FileReadResult> templates,
    List<InsightMapper<TInsight, TPlaceholder>> insightMappers,
  ) get converge => (insights, templates, insightMappers) async {
        final produceReplacements =
            ReplacementProducer(() async => insightMappers).produceReplacements;
        final replacements = await Future.wait(
          insights.map(
            (a) {
              return produceReplacements(a).then((b) {
                return Replacements(
                  insight: a,
                  replacements: b,
                );
              });
            },
          ),
        );
        await this._converge(
          replacements,
          templates,
        );
      };
}
