//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of '../type_codes.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Mapper event base class.
abstract class MapperEvent {
  /// The name of the field, e.g. "firstName" or "p3".
  String? get name =>
      this._name ?? (this._nameIndex != null ? 'p${this._nameIndex}' : null);
  String? _name;

  /// The index of the generated field name, e.g. "p3" = 3.
  int? get nameIndex => this._nameIndex;
  int? _nameIndex;

  /// The field type, e.g. "String?".
  String? get type => this._type;
  String? _type;

  // /// The type code, e.g. TypeCode("String?").
  // TypeCode? get typeCode => this._type != null ? TypeCode(this._type!) : null;

  /// Regex match groups.
  Iterable<String>? get matchGroups => this._matchGroups;
  Iterable<String>? _matchGroups;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Mapper event for collection types, e.g. Map, List, Set.
class CollectionMapperEvent extends MapperEvent {
  Iterable<String> _largs = [];
  Iterable<String> _lhashes = [];
  Iterable<String> _lparams = [];
  Iterable<String> _ltypes = [];
  Iterable<String> get largs => this._largs;
  Iterable<String> get lhashes => this._lhashes;
  Iterable<String> get lparams => this._lparams;
  Iterable<String> get ltypes => this._ltypes;
  String get args => this._largs.join(', ');
  String get hashes => this._lhashes.join(', ');
  String get params => this._lparams.join(', ');
  String get types => this._ltypes.join(', ');
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Mapper event for non-collection types, e.g. int, String, DateTime.
class ObjectMapperEvent extends MapperEvent {
  ObjectMapperEvent();

  ObjectMapperEvent.custom(String name, Iterable<String> matchGroups) {
    this._name = name;
    this._matchGroups = matchGroups;
  }
}
