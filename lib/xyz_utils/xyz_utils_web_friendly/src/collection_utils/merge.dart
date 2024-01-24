//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:collection/collection.dart' show mergeMaps;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

T mergeListsOrSets<T extends Iterable>(T a, dynamic b) {
  final aa = a is List
      ? List.of(a)
      : a is Set
          ? Set.of(a)
          : null;
  final bb = b is List
      ? List.of(b)
      : b is Set
          ? Set.of(b)
          : null;
  if (aa == null) {
    throw Error();
  }
  return bb == null ? ((aa as dynamic)..add(b)) : ((aa as dynamic)..addAll(bb));
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Iterable mergeIterables(dynamic a, dynamic b) {
  final aa = a is Iterable ? a : [a];
  final bb = b is Iterable ? b : [b];
  return aa.followedBy(bb);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

dynamic mergeDataDeep(
  dynamic a,
  dynamic b, [
  dynamic Function(dynamic)? elseFilter,
]) {
  if (a is Map && b is Map) {
    return mergeMaps(
      a,
      b,
      value: (final a, final b) {
        if (a is Map && b is Map) {
          return mergeDataDeep(a, b, elseFilter);
        }
        if (a is List || a is Set) {
          return mergeListsOrSets<Iterable>(a as Iterable, b);
        }
        if (a is Iterable) {
          return mergeIterables(a, b);
        }
        return elseFilter?.call(b) ?? b;
      },
    );
  }
  if (a is List || a is Set) {
    return mergeListsOrSets<Iterable>(a as Iterable, b);
  }
  if (a is Iterable) {
    return mergeIterables(a, b);
  }
  return elseFilter?.call(b) ?? b;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

dynamic mergeDataDeepIncludeCalls_toJson(dynamic a, dynamic b) {
  return mergeDataDeep(a, b, tryCallingOnObject_toJson);
}

dynamic mergeDataDeepIncludeCalls_toMap(dynamic a, dynamic b) {
  return mergeDataDeep(a, b, tryCallingOnObject_toMap);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

dynamic tryCallingOnObject_toJson(dynamic object) {
  try {
    return object?.toJson();
  } catch (_) {
    return null;
  }
}

dynamic tryCallingOnObject_toMap(dynamic object) {
  try {
    return object?.toMap();
  } catch (_) {
    return null;
  }
}
