//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

/// Expands some non-generic Dart collection types to their generic forms
/// (e.g. Map to Map<dynamic, dynamic>). It processes types separated by "|"
/// and skips over collections that already specify types.
///
/// This only works for the following types:
///
/// - Map
/// - List
/// - Set
/// - Iterable
/// - Queue
/// - LinkedList
/// - HashSet
/// - LinkedHashSet
/// - HashMap
/// - LinkedHashMap
String toGenericDartType(String fieldTypeCode) {
  for (final e in {
    'Map': 'Map<dynamic, dynamic>',
    'List': 'List<dynamic>',
    'Set': 'Set<dynamic>',
    'Iterable': 'Iterable<dynamic>',
    'Queue': 'Queue<dynamic>',
    'LinkedList': 'LinkedList<dynamic>',
    'HashSet': 'HashSet<dynamic>',
    'LinkedHashSet': 'LinkedHashSet<dynamic>',
    'HashMap': 'HashMap<dynamic, dynamic>',
    'LinkedHashMap': 'LinkedHashMap<dynamic, dynamic>',
  }.entries) {
    final key = e.key;
    final value = e.value;
    // This regex looks for the key (like "Map") that is not immediately
    // followed by a "<", but it will also match if the key is followed by "|"
    // and any text.
    final regex = RegExp(r'\b' + key + r'\b(?![<|])');
    fieldTypeCode = fieldTypeCode.replaceAll(regex, value);
  }
  return fieldTypeCode;
}
