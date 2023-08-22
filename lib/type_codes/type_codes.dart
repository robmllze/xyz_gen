// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'loose_type_mappers.dart';

part '_builders.dart';
part '_helpers.dart';
part '_mapper_event.dart';
part '_type_code_mapper.dart';
part '_type_mappers.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String mapWithLooseToMappers({required String fieldName, required String typeCode}) {
  final mappers = LooseTypeMappers.instance.toMappers;
  return TypeCodeMapper(mappers).map(
    fieldName: fieldName,
    typeCode: typeCode,
  );
}

String mapWithLooseFromMappers({required String fieldName, required String typeCode}) {
  final mappers = LooseTypeMappers.instance.fromMappers;
  return TypeCodeMapper(mappers).map(
    fieldName: fieldName,
    typeCode: typeCode,
  );
}
