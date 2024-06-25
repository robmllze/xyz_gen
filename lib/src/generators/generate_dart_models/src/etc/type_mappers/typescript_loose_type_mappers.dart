// //.title
// // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
// //
// // 🇽🇾🇿 & Dev
// //
// // Licencing details are in the LICENSE file in the root directory.
// //
// // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
// //.title~

// import '/_common.dart';

// // ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// class TypescriptLooseTypeMappers extends TypeMappers {
//   //
//   //
//   //

//   static final instance = TypescriptLooseTypeMappers._();

//   //
//   //
//   //

//   TypescriptLooseTypeMappers._();

//   //
//   //
//   //

//   @override
//   TTypeMappers get collectionFromMappers => newTypeMappers({});

//   //
//   //
//   //

//   @override
//   TTypeMappers get collectionToMappers => newTypeMappers({});

//   //
//   //
//   //

//   @override
//   TTypeMappers get objectFromMappers => newTypeMappers({
//         r'^(String)\??$': (e) {
//           if (e is! ObjectMapperEvent) throw TypeError();
//           return '${e.name}?.toString().trim()';
//         },
//         r'^(\w+)\??$': (e) {
//           if (e is! ObjectMapperEvent) throw TypeError();
//           return '${e.name}';
//         },
//       });

//   //
//   //
//   //

//   @override
//   TTypeMappers get objectToMappers => newTypeMappers({
//         r'^(String)\??$': (e) {
//           if (e is! ObjectMapperEvent) throw TypeError();
//           return '${e.name}?.toString().trim().nullIfEmpty';
//         },
//         r'^(\w+)\??$': (e) {
//           if (e is! ObjectMapperEvent) throw TypeError();
//           return '${e.name}';
//         },
//       });
// }
