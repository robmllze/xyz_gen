//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

/// Mapper event for collection types, e.g. Map, List, Set.
final class CollectionMapperEvent extends MapperEvent {
  Iterable<String> _largs = [];
  Iterable<String> _lhashes = [];
  Iterable<String> _lparams = [];
  Iterable<String> _ltypes = [];
  String get args => this._largs.join(', ');
  String get hashes => this._lhashes.join(', ');
  String get params => this._lparams.join(', ');
  String get types => this._ltypes.join(', ');
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String buildCollectionMapper(
  Iterable<List<String>> typeData,
  TTypeMappers mappers,
) {
  var output = '#x0';
  // Loop through type data elements.
  for (final element in typeData) {
    final collectionEvent = CollectionMapperEvent().._ltypes = element.skip(2);
    final pLength = collectionEvent._ltypes.length;
    collectionEvent
      .._lhashes = Iterable.generate(pLength, (n) => n).map((n) => '#p$n')
      .._lparams = Iterable.generate(pLength, (n) => n).map((n) => 'p$n')
      .._largs = Iterable.generate(pLength, (n) => n).map((n) => 'p$n')
      .._type = element[1];
    final argIdMatch = RegExp(r'#x(\d+)').firstMatch(output);
    collectionEvent._nameIndex = argIdMatch != null && argIdMatch.groupCount > 0 //
        ? int.tryParse(argIdMatch.group(1)!)
        : null;
    final xHash = '#x${collectionEvent._nameIndex}';
    final formula = _buildMapper(collectionEvent, mappers);
    if (formula != null) {
      output = output.replaceFirst(xHash, formula);
    } else {
      assert(false, 'Collection type-mapper not found!');
    }
    // Loop through object types.
    for (var n = 0; n < pLength; n++) {
      final objectEvent = ObjectMapperEvent()
        .._nameIndex = n
        .._type = collectionEvent._ltypes.elementAt(n);
      final pHash = '#p$n';

      // If the object type is the next type data element.
      if (objectEvent.type?[0] == '*') {
        final xHash = '#x$n';
        output = output.replaceFirst(pHash, xHash);
      }
      // If the object type is something else like num, int, double, bool or
      // String.
      else {
        final formula = _buildMapper(objectEvent, mappers);
        if (formula != null) {
          output = output.replaceFirst(pHash, formula);
        } else {
          assert(false, 'Object type-mapper not found!');
        }
      }
    }
  }
  return output;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Mapper event for non-collection types, e.g. int, String, DateTime.
final class ObjectMapperEvent extends MapperEvent {
  ObjectMapperEvent();

  ObjectMapperEvent.custom(String name, Iterable<String> matchGroups) {
    this._name = name;
    this._matchGroups = matchGroups;
  }
}

String? buildObjectMapper(
  String type,
  String fieldName,
  TTypeMappers mappers,
) {
  final event = ObjectMapperEvent()
    .._type = type
    .._name = fieldName;
  return _buildMapper(event, mappers);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Mapper event base class.
abstract base class MapperEvent {
  /// The name of the field, e.g. "firstName" or "p3".
  String? get name => this._name ?? (this._nameIndex != null ? 'p${this._nameIndex}' : null);
  String? _name;

  /// The index of the generated field name, e.g. "p3" = 3.
  int? get nameIndex => this._nameIndex;
  int? _nameIndex;

  /// The field type, e.g. "String?".
  String? get type => this._type;
  String? _type;

  /// Regex match groups.
  Iterable<String>? get matchGroups => this._matchGroups;
  Iterable<String>? _matchGroups;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String? _buildMapper(
  MapperEvent event,
  TTypeMappers mappers,
) {
  final type = event.type;
  if (type != null) {
    // Get all mappers that match the type.
    final results = filterMappersByType(
      mappers,
      type,
    );
    assert(results.isNotEmpty);
    // If there are any matches, take the first one.
    if (results.isNotEmpty) {
      final result = results.entries.first;
      final typePattern = result.key;
      final match = RegExp(typePattern).firstMatch(type);
      if (match != null) {
        event._matchGroups = Iterable.generate(match.groupCount + 1, (i) => match.group(i)!);
        final eventMapper = result.value;
        return eventMapper(event);
      }
    }
  }
  return null;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Searches [mappers] for mappers that match the given [type] and returns them.
TTypeMappers filterMappersByType(
  TTypeMappers mappers,
  String type,
) {
  return Map.fromEntries(
    mappers.entries.where((e) {
      final key = e.key;
      return RegExp(key).hasMatch(type);
    }),
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

typedef TTypeMappers<E extends MapperEvent> = Map<String, String Function(E event)>;

TTypeMappers newTypeMappers(TTypeMappers input) => TTypeMappers.unmodifiable(input);

TTypeMappers<E> newTypeMappers1<E extends MapperEvent>(Iterable<_P> input) =>
    TTypeMappers.unmodifiable(_map1(input));

abstract class TypeMappers {
  TTypeMappers get fromMappers => {...this.collectionFromMappers, ...this.objectFromMappers};
  TTypeMappers get toMappers => {...this.collectionToMappers, ...this.objectToMappers};
  TTypeMappers get collectionFromMappers;
  TTypeMappers get collectionToMappers;
  TTypeMappers get objectFromMappers;
  TTypeMappers get objectToMappers;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Map<String, _TMapper<E>> _map<E extends MapperEvent>(
  Iterable<Map<String, _TMapper>> entries,
) {
  return Map.fromEntries(
    entries.map(
      (e) {
        final length = e.entries.length;
        if (length != 1) throw Error();
        return e.entries.first;
      },
    ),
  );
}

Map<String, _TMapper<E>> _map1<E extends MapperEvent>(
  Iterable<_P> params,
) {
  return _map<E>(params.map((e) => mapper(e)));
}

Map<String, _TMapper<E>> mapper<E extends MapperEvent>(_P<E> p) {
  return {
    p.$1: (e) {
      if (e is! E) throw TypeError();
      return p.$2(e);
    },
  }.cast();
}

typedef _P<E extends MapperEvent> = (
  String pattern,
  _TMapper<E> mapper,
);

typedef _TMapper<E extends MapperEvent> = String Function(E e);
