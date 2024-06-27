//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/src/xyz/_all_xyz.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class DartTypeCodeMapper {
  //
  //
  //

  final TTypeMappers mappers;

  //
  //
  //

  const DartTypeCodeMapper(this.mappers);

  //
  //
  //

  String map({
    required String fieldName,
    required String fieldTypeCode,
  }) {
    var result = this.mapCollection(
      fieldName: fieldName,
      genericTypeCode: fieldTypeCode,
    );
    if (result == '#x0') {
      result = this.mapObject(
        fieldName: fieldName,
        fieldTypeCode: fieldTypeCode,
      );
    }
    return result;
  }

//
//
//

  String mapObject({
    required String fieldName,
    required String fieldTypeCode,
  }) {
    final formula = buildObjectMapper(fieldTypeCode, fieldName, this.mappers) ?? '#x0';
    return formula;
  }

//
//
//

  String mapCollection({
    required String fieldName,
    required String genericTypeCode,
  }) {
    // Break the typeCode up into to a list of type data that can be processed
    // by the builder.
    final typeData = decomposeDartCollectionType(genericTypeCode);
    // Use the typeData to build a mapping formula.
    var formula = buildCollectionMapper(typeData, this.mappers);
    // Insert the field name into the formula.
    formula = formula.replaceFirst('p0', fieldName);
    return formula;
  }
}
