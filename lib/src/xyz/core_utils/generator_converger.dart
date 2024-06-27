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
import 'replacements.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GeneratorConverger<TInsight extends Insight, TPlaceholder extends Enum> {
  //
  //
  //

  final Future<void> Function(
    Iterable<Replacements<TInsight>> insights,
    Map<String, String> templates,
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
    Map<String, String> templates,
    List<InsightMapper<TInsight, TPlaceholder>> insightMappers,
  ) get converge => (insights, templates, insightMappers) async {
        final produceReplacements =
            ReplacementProducer(() async => insightMappers).produceReplacements;
        final replacements = await Future.wait(insights.map(
            (a) => produceReplacements(a).then((b) => Replacements(insight: a, replacements: b))));
        this._converge(replacements, templates);
      };
}