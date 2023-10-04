// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:xyz_utils/xyz_utils_non_web.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract class Model {
  String? id;

  dynamic args;

  String? collectionPath;

  Map<String, dynamic> toJMap();

  T copy<T extends Model>();

  T copyWith<T extends Model>(T other);

  T copyWithJMap<T extends Model>(JMap other);

  void updateWith<T extends Model>(T other);

  void updateWithJMap<T extends Model>(JMap other);

  @override
  String toString() => this.toJMap().toString();

  bool equals<T extends Model>(T other) => this.toJMap().deep == other.toJMap().deep;

  FirestoreRef? defaultFsRef(dynamic firestore) {
    return collectionPath != null && this.id != null
        ? FirestoreRef._(firestore, this.collectionPath!, this.id!)
        : null;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract class ThisModel<T extends Model> extends Model {
  late final T model = this as T;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class FirestoreRef {
  final dynamic firestore;
  final String collectionPath;
  final String id;
  const FirestoreRef._(this.firestore, this.collectionPath, this.id);
  dynamic get collectionRef => this.firestore.collection(this.collectionPath);
  dynamic get docRef => this.collectionRef().doc(this.id);
}
