import 'sample.dart';

/// Equivalent of [Category]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [Category.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [CategoryType] permissions provided.
///
class Category extends Sample<CategoryHarmonized> {
  const Category(
    super.uuid,
    super.identifier,
    super.startTimestamp,
    super.endTimestamp,
    super.device,
    super.sourceRevision,
    super.harmonized,
  );

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'uuid': uuid,
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'device': device?.map,
        'sourceRevision': sourceRevision.map,
        'harmonized': harmonized.map,
      };

  /// General constructor from JSON payload
  ///
  Category.fromJson(Map<String, dynamic> json) : super.from(json, CategoryHarmonized.fromJson(json['harmonized']));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Category> collect(List<dynamic> list) {
    final samples = <Category>[];
    for (final Map<String, dynamic> map in list) {
      final sample = Category.fromJson(map);
      samples.add(sample);
    }
    return samples;
  }
}

/// Equivalent of [Category.Harmonized]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [CategoryHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// To create valid instances of [CategoryHarmonized] please refer to Apple documentation
///
class CategoryHarmonized {
  const CategoryHarmonized(
    this.value,
    this.description,
    this.detail,
    this.metadata,
  );

  final num value;
  final String description;
  final String detail;
  final Map<String, dynamic>? metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'value': value,
        'description': description,
        'detail': detail,
        'metadata': metadata,
      };

  /// General constructor from JSON payload
  ///
  CategoryHarmonized.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        description = json['description'],
        detail = json['detail'],
        metadata = json['metadata'];
}
