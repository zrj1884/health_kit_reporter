import 'package:health_kit_reporter/model/type/electrocardiogram_type.dart';

import 'sample.dart';

/// Equivalent of [Electrocardiogram]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [Electrocardiogram.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// Requires [ElectrocardiogramType] permissions provided.
///
class Electrocardiogram extends Sample<ElectrocardiogramHarmonized> {
  const Electrocardiogram(
    super.uuid,
    super.identifier,
    super.startTimestamp,
    super.endTimestamp,
    super.device,
    super.sourceRevision,
    super.harmonized,
    this.numberOfMeasurements,
  );

  final int numberOfMeasurements;

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
        'numberOfMeasurements': numberOfMeasurements,
      };

  /// General constructor from JSON payload
  ///
  Electrocardiogram.fromJson(Map<String, dynamic> json)
      : numberOfMeasurements = json['numberOfMeasurements'],
        super.from(json, ElectrocardiogramHarmonized.fromJson(json['harmonized']));
}

/// Equivalent of [Electrocardiogram.Harmonized]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [ElectrocardiogramHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class ElectrocardiogramHarmonized {
  const ElectrocardiogramHarmonized(
    this.averageHeartRate,
    this.averageHeartRateUnit,
    this.samplingFrequency,
    this.samplingFrequencyUnit,
    this.classification,
    this.symptomsStatus,
    this.count,
    this.voltageMeasurements,
    this.metadata,
  );

  final num averageHeartRate;
  final String averageHeartRateUnit;
  final num samplingFrequency;
  final String samplingFrequencyUnit;
  final String classification;
  final String symptomsStatus;
  final int count;
  final List<ElectrocardiogramVoltageMeasurement> voltageMeasurements;
  final Map<String, dynamic>? metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'averageHeartRate': averageHeartRate,
        'averageHeartRateUnit': averageHeartRateUnit,
        'samplingFrequency': samplingFrequency,
        'samplingFrequencyUnit': samplingFrequencyUnit,
        'classification': classification,
        'symptomsStatus': symptomsStatus,
        'count': count,
        'voltageMeasurements': voltageMeasurements.map((e) => e.map).toList(),
        'metadata': metadata,
      };

  /// General constructor from JSON payload
  ///
  ElectrocardiogramHarmonized.fromJson(Map<String, dynamic> json)
      : averageHeartRate = json['averageHeartRate'],
        averageHeartRateUnit = json['averageHeartRateUnit'],
        samplingFrequency = json['samplingFrequency'],
        samplingFrequencyUnit = json['samplingFrequencyUnit'],
        classification = json['classification'],
        symptomsStatus = json['symptomsStatus'],
        count = json['count'],
        voltageMeasurements = ElectrocardiogramVoltageMeasurement.collect(json['voltageMeasurements']),
        metadata = json['metadata'];
}

/// Equivalent of [Electrocardiogram.VoltageMeasurement]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [ElectrocardiogramVoltageMeasurement.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class ElectrocardiogramVoltageMeasurement {
  const ElectrocardiogramVoltageMeasurement(
    this.harmonized,
    this.timeSinceSampleStart,
  );

  final ElectrocardiogramVoltageMeasurementHarmonized harmonized;
  final num timeSinceSampleStart;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'harmonized': harmonized.map,
        'timeSinceSampleStart': timeSinceSampleStart,
      };

  /// General constructor from JSON payload
  ///
  ElectrocardiogramVoltageMeasurement.fromJson(Map<String, dynamic> json)
      : harmonized = ElectrocardiogramVoltageMeasurementHarmonized.fromJson(json['harmonized']),
        timeSinceSampleStart = json['timeSinceSampleStart'];

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<ElectrocardiogramVoltageMeasurement> collect(List<dynamic> list) {
    final measurements = <ElectrocardiogramVoltageMeasurement>[];
    for (final Map<String, dynamic> map in list) {
      final sample = ElectrocardiogramVoltageMeasurement.fromJson(map);
      measurements.add(sample);
    }
    return measurements;
  }
}

/// Equivalent of [Electrocardiogram.VoltageMeasurement.Harmonized]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [ElectrocardiogramVoltageMeasurementHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class ElectrocardiogramVoltageMeasurementHarmonized {
  const ElectrocardiogramVoltageMeasurementHarmonized(
    this.value,
    this.unit,
  );

  final num value;
  final String unit;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
      };

  /// General constructor from JSON payload
  ///
  ElectrocardiogramVoltageMeasurementHarmonized.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        unit = json['unit'];
}
