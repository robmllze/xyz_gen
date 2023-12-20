//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen / XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Set<String> getAllPathCombinations(List<Set<String>> paths) {
  late Set<String> output;

  // Filter out empty sets.
  final input = List.of(paths).where((e) => e.isNotEmpty).toList();

  // If the input is empty, the output is empty.
  if (input.isEmpty) {
    output = {};
  } else
  // If there's only one set, the output is that set.
  if (input.length == 1) {
    output = input[0];
  } else {
    // Join the first two sets and replace them with their joined set, then
    // recursively call this function.
    final first = input[0];
    final second = input[1];
    final joined = <String>{};

    for (final f in first) {
      for (final s in second) {
        if (s.isEmpty) {
          joined.add(f);
        } else if (f.isEmpty) {
          joined.add(s);
        } else {
          joined.add(p.join(f, s));
        }
      }
    }
    // Replace the first two sets in the list with their joined set.
    output = getAllPathCombinations([joined, ...input.skip(2)]);
  }

  return output;
}
