// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

typedef TTypeMappers = Map<String, String Function(_MapperEvent)>;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class TypeCodeMapper {
  //
  //
  //

  final TTypeMappers mappers;

  //
  //
  //

  const TypeCodeMapper([this.mappers = const {}]);

  //
  //
  //

  String map(String typeCode, String fieldName) {
    final a = this.mapObject(typeCode, fieldName);
    final b = this.mapCollection(typeCode, fieldName);
    final c = b.replaceFirst("#x0", a);
    return c;
  }

  //
  //
  //

  String mapObject(String typeCode, String fieldName) {
    final formula = _buildObjectMapper(typeCode, fieldName, this.mappers) ?? "#x0";
    return formula;
  }

  //
  //
  //

  String mapCollection(String typeCode, String fieldName) {
    // Break the typeCode up into to a list of type data that can be processed
    // by the builder.
    final typeData = preprocessCollectionTypeCode(typeCode);
    // Use the typeData to build a mapping formula.
    var formula = _buildCollectionMapper(typeData, this.mappers);
    // Insert the field name into the formula.
    formula = formula.replaceFirst("p0", fieldName);
    return formula;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String? _buildObjectMapper(
  String type,
  String fieldName,
  TTypeMappers mappers,
) {
  // Get all mappers that match the type.
  final results = filterMappersByType(
    mappers,
    type,
  );
  // If there are any matches, take the first one.
  if (results.isNotEmpty) {
    final result = results.entries.first;
    final typePattern = result.key;
    final match = RegExp(typePattern).firstMatch(type);
    if (match != null) {
      final event = ObjectMapperEvent.custom(
        fieldName,
        Iterable.generate(match.groupCount + 1, (i) => match.group(i)!),
      );
      final eventMapper = result.value;
      return eventMapper(event);
    }
  }
  return null;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Iterable<List<String>> preprocessCollectionTypeCode(String typeCode) {
  final unsorted = <int, List<String>>{};
  String? parse(String typeCode) {
    // Remove all spaces from the type code.
    var input = typeCode.replaceAll(" ", "");
    const A = r"[\w\*\|\?]+";
    const B = r"\b(" "$A" r")\<((" "$A" r")(\," "$A" r")*)\>(\?)?";
    final entries = RegExp(B).allMatches(input).map((e) {
      final longType = e.group(0)!;
      final shortType = e.group(1)!;
      final subtypes = e.group(2)!.split(",");
      final nullable = e.group(5);
      return MapEntry(e.start, [longType, "$shortType${nullable ?? ""}", ...subtypes]);
    });
    unsorted.addEntries(entries);

    for (final entry in entries) {
      final first = entry.value.first;
      input = input.replaceFirst(first, "*" * first.length);
    }
    return entries.isEmpty ? null : input;
  }

  String? c = typeCode;
  do {
    c = parse(c!);
  } while (c != null);
  final entries = unsorted.entries.toList();
  entries.sort((a, b) => a.key.compareTo(b.key));
  final values = entries.map((e) => e.value);
  return values;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

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

String? _mapped(
  _MapperEvent event,
  TTypeMappers mappers,
) {
  final type = event.type;
  if (type != null) {
    final all = filterMappersByType(mappers, type);
    assert(all.length <= 1, "Multiple mapper matches found!");
    if (all.length == 1) {
      final first = all.entries.first;
      final mapper = first.value;
      final regExp = RegExp(first.key);
      final match = regExp.firstMatch(type)!;
      event._matchGroups = Iterable.generate(match.groupCount + 1, (i) => match.group(i)!);
      return mapper(event);
    }
  }
  return null;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _buildCollectionMapper(
  Iterable<List<String>> typeData,
  TTypeMappers mappingFormulas,
) {
  var output = "#x0";
  // Loop through type data elements.
  for (final element in typeData) {
    final collectionEvent = CollectionMapperEvent().._ltypes = element.skip(2);
    final pLength = collectionEvent._ltypes.length;
    collectionEvent
      .._lhashes = Iterable.generate(pLength, (e) => e).map((l) => "#p$l")
      .._lparams = Iterable.generate(pLength, (e) => e).map((l) => "p$l")
      .._largs = Iterable.generate(pLength, (e) => e).map((l) => "final p$l")
      .._type = element[1];
    final argIdMatch = RegExp(r"#x(\d+)").firstMatch(output);
    collectionEvent._nameIndex = argIdMatch != null && argIdMatch.groupCount > 0 //
        ? int.tryParse(argIdMatch.group(1)!)
        : null;
    final xHash = "#x${collectionEvent._nameIndex}";
    final mapped = _mapped(collectionEvent, mappingFormulas);
    if (mapped != null) {
      output = output.replaceFirst(xHash, mapped);
    } else {
      assert(false, "Collection type-mapper not found!");
    }
    // Loop through object types.
    for (var n = 0; n < pLength; n++) {
      final objectEvent = ObjectMapperEvent()
        .._nameIndex = n
        .._type = collectionEvent._ltypes.elementAt(n);
      final pHash = "#p$n";

      // If the object type is the next type data element.
      if (objectEvent.type?[0] == "*") {
        final xHash = "#x$n";
        output = output.replaceFirst(pHash, xHash);
      }
      // If the object type is something else like num, int, double, bool or
      // String.
      else {
        final mapped = _mapped(objectEvent, mappingFormulas);
        if (mapped != null) {
          output = output.replaceFirst(pHash, mapped);
        } else {
          assert(false, "Object type-mapper not found!");
        }
      }
    }
  }
  return output;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract class _MapperEvent {
  /// The name of the field, e.g. "firstName" or "p3".
  String? get name => this._name ?? (this._nameIndex != null ? "p${this._nameIndex}" : null);

  // The index of the generated field name, e.g. "p3" = 3.
  int? get nameIndex => this._nameIndex;

  // The field type, e.g. "String?".
  String? get type => this._type;

  Iterable<String>? get matchGroups => this._matchGroups;

  String? _name;
  int? _nameIndex;
  String? _type;
  Iterable<String>? _matchGroups;
}

/// Mapper event for collection types, e.g. Map, List, Set.
class CollectionMapperEvent extends _MapperEvent {
  Iterable<String> _largs = [];
  Iterable<String> _lhashes = [];
  Iterable<String> _lparams = [];
  Iterable<String> _ltypes = [];
  Iterable<String> get largs => this._largs;
  Iterable<String> get lhashes => this._lhashes;
  Iterable<String> get lparams => this._lparams;
  Iterable<String> get ltypes => this._ltypes;
  String get args => this._largs.join(", ");
  String get hashes => this._lhashes.join(", ");
  String get params => this._lparams.join(", ");
  String get types => this._ltypes.join(", ");
}

/// Mapper event for non-collection types, e.g. int, String, DateTime.
class ObjectMapperEvent extends _MapperEvent {
  ObjectMapperEvent();
  ObjectMapperEvent.custom(String name, Iterable<String> matchGroups) {
    this._name = name;
    this._matchGroups = matchGroups;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String typeCodeToType(String typeCode) {
  var temp = typeCode //
      .replaceAll(" ", "")
      .replaceAll("|let", "");
  while (true) {
    final match = RegExp(r"\w+\|clean\<([\w\[\]\+]+\??)(,[\w\[\]\+]+\??)*\>").firstMatch(temp);
    if (match == null) break;
    final group0 = match.group(0);
    if (group0 == null) break;
    temp = temp.replaceAll(
      group0,
      group0
          .replaceAll("|clean", "")
          .replaceAll("?", "")
          .replaceAll("<", "[")
          .replaceAll(">", "]")
          .replaceAll(",", "+"),
    );
  }
  return temp //
      .replaceAll("[", "<")
      .replaceAll("]", ">")
      .replaceAll("+", ", ");
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final defaultToMappers = TTypeMappers.unmodifiable({
  r"^Map$": /* clean */ (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "${e.name}.map((${e.args}) => MapEntry(${e.hashes},),).nonNulls.nullIfEmpty";
  },
  r"^Map\?$": /* clean */ (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "${e.name}?.map((${e.args}) => MapEntry(${e.hashes},),).nonNulls.nullIfEmpty";
  },
  //
  r"^List$": /* clean */ (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "${e.name}.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toList()";
  },
  r"^List\?$": /* clean */ (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "${e.name}?.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toList()";
  },
  //
  r"^Set$": /* clean */ (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "${e.name}.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toList()";
  },
  r"^Set\?$": /* clean */ (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "${e.name}?.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toList()";
  },
  //
  r"^(dynamic|bool|num|int|double)\??$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}";
  },
  //
  r"^Timestamp$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}.microsecondsSinceEpoch";
  },
  r"^Timestamp\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}?.microsecondsSinceEpoch";
  },
  //
  r"^Duration$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}.inMicroseconds";
  },
  r"^Duration\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}?.inMicroseconds";
  },
  //
  r"^String$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}.nullIfEmpty";
  },
  r"^String\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}?.nullIfEmpty";
  },
  //
  r"^Uri$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}.toString().nullIfEmpty";
  },
  r"^Uri\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}?.toString().nullIfEmpty";
  },
  //
  // r"^DateTime$": (e) {
  //   if (e is! MapperSubEvent) throw TypeError();
  //   return "${e.p}.toUtc().toIso8601String()";
  // },
  // r"^DateTime\?$": (e) {
  //   if (e is! MapperSubEvent) throw TypeError();
  //   return "${e.p}?.toUtc().toIso8601String()";
  // },
  //
  r"^DateTime$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "Timestamp.fromDate(${e.name})";
  },
  r"^DateTime\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "(){ final a = ${e.name}; return a != null ? Timestamp.fromDate(a): null; }()";
  },
  //
  r"^\w+Type$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}.name";
  },
  r"^\w+Type\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}?.name";
  },
});

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final newFromMappers = TTypeMappers.unmodifiable({
  r"^String[\?]?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "(${e.name}?.toString())";
  },
});

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final defaultFromMappers = TTypeMappers.unmodifiable({
  r"^Map$": (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "(${e.name} as Map).map((${e.args}) => MapEntry(${e.hashes},),)";
  },
  r"^Map\?$": (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "letAs<Map>(${e.name})?.map((${e.args}) => MapEntry(${e.hashes},),)";
  },
  r"^Map\|clean$": (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "(${e.name} as Map).map((${e.args}) => MapEntry(${e.hashes},),).nonNulls.nullIfEmpty";
  },
  r"^Map\|clean\?$": (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "letAs<Map>(${e.name})?.map((${e.args}) => MapEntry(${e.hashes},),).nonNulls.nullIfEmpty";
  },
  //
  r"^List$": (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "(${e.name} as List).map((${e.args}) => ${e.hashes},).toList()";
  },
  r"^List\?$": (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "letAs<List>(${e.name})?.map((${e.args}) => ${e.hashes},).toList()";
  },
  r"^List\|clean$": (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "(${e.name} as List).map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toList()";
  },
  r"^List\|clean\?$": (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "letAs<List>(${e.name})?.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toList()";
  },
  //
  r"^Set$": (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "(${e.name} as Set).map((${e.args}) => ${e.hashes},).toSet()";
  },
  r"^Set\?$": (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "letAs<List>(${e.name})?.map((${e.args}) => ${e.hashes},).toSet()";
  },
  r"^Set\|clean$": (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "(${e.name} as List).map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toSet()";
  },
  r"^Set\|clean\?$": (e) {
    if (e is! CollectionMapperEvent) throw TypeError();
    return "letAs<List>(${e.name})?.map((${e.args}) => ${e.hashes},).nonNulls.nullIfEmpty?.toSet()";
  },
  //
  r"^dynamic$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}";
  },
  r"^dynamic\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}";
  },
  //
  r"^bool$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "(${e.name} as bool)";
  },
  r"^bool\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letAs<bool>(${e.name})";
  },
  r"^bool\|let\??$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letBool(${e.name})";
  },
  //
  r"^num$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "(${e.name} as num)";
  },
  r"^num\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letAs<num>(${e.name})";
  },
  r"^num\|let\??$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letNum(${e.name})";
  },
  //
  r"^int$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "(${e.name} as int)";
  },
  r"^int\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letAs<int>(${e.name})";
  },
  r"^int\|let\??$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letInt(${e.name})";
  },
  //
  r"^Duration$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "Duration(microseconds: ${e.name} as int)";
  },
  r"^Duration\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "() { final a = letAs<int>(${e.name}); return a != null ? Duration(microseconds: a): null; }()";
  },
  r"^Duration\|let\??$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "() { final a = letInt(${e.name}); return a != null ? Duration(microseconds: a): null; }()";
  },
  //
  r"^Timestamp$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "Timestamp.fromMicrosecondsSinceEpoch(${e.name} as int)";
  },
  r"^Timestamp\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "() { final a = letAs<int>(${e.name}); return a != null ?  Timestamp.fromMicrosecondsSinceEpoch(a): null; }()";
  },
  r"^Timestamp\|let\??$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "() { final a = letInt(${e.name}); return a != null ? Timestamp.fromMicrosecondsSinceEpoch(a): null; }()";
  },
  //
  r"^double$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "(${e.name} as double)";
  },
  r"^double\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letAs<double>(${e.name})";
  },
  r"^double\|let\??$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letDouble(${e.name})";
  },
  //
  r"^String$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "(${e.name}.toString())";
  },
  r"^String\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "(${e.name}?.toString())";
  },
  r"^String\|let\??$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letString(${e.name})";
  },
  //
  r"^Uri$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "Uri.parse(${e.name}.toString())";
  },
  r"^Uri\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "(){ final a = ${e.name}?.toString(); return a == null? null: Uri.tryParse(a); }()";
  },
  //
  // r"^DateTime$": (e) {
  //   if (e is! MapperSubEvent) throw TypeError();
  //   return "DateTime.parse(${e.p}.toString())";
  // },
  // r"^DateTime\?$": (e) {
  //   if (e is! MapperSubEvent) throw TypeError();
  //   return "DateTime.tryParse(${e.p}.toString())";
  // },
  // r"^DateTime\|let\??$": (e) {
  //   if (e is! MapperSubEvent) throw TypeError();
  //   return "letDateTime(${e.p})";
  // },
  //
  r"^DateTime$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "(${e.name} as Timestamp).toDate()";
  },
  r"^DateTime\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "(${e.name} as Timestamp?)?.toDate()";
  },
  r"^DateTime\|let\??$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letTimestamp(${e.name})?.toDate()";
  },
  //
  r"^\w+Type$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "nameTo${e.matchGroups?.elementAt(0)}(letAs<String>(${e.name}))!";
  },
  r"^(\w+Type)\?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "nameTo${e.matchGroups?.elementAt(1)}(letAs<String>(${e.name}))";
  },
});
