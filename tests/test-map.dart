import 'package:xyz_gen/xyz_gen.dart';

void main() {
  var data = <String, dynamic>{};

  var entries = [
    const MapEntry('meta.token', '123'),
    const MapEntry('user.firstName', 'Bob'),
    const MapEntry('user.lastName', 'Marley'),
    const MapEntry('meta.pictureUrl', 'url'),
    const MapEntry('meta.more.id', '456'),
    const MapEntry('meta.more', {'k': 'z'}),
  ];

  for (var entry in entries..sort((a, b) => b.key.compareTo(a.key))) {
    setValueInMap(data, [entry.key], entry.value, '.');
  }
  data['meta']?['#'] = '...?meta';
  data.toString().replaceAll('#:', '');
}

void setValueInMap(Map<String, dynamic> data, List<String> keys0, dynamic value, String splitBy) {
  final key1 = keys0.map((e) => e.split(splitBy)).reduce((a, b) => [...a, ...b]).toSet().toList();
  if (key1.length > 1) {
    for (var n = 0; n < key1.length - 1; n++) {
      final k = key1.elementAt(n);
      data = (data[k] ??= <String, dynamic>{});
    }
  }
  final d1 = data[key1.last];
  if (d1 is Map && value is Map) {
    data[key1.last] = {...d1, ...value};
  } else {
    data[key1.last] = value;
  }
}
