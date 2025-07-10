import 'package:health_kit_reporter/model/payload/device.dart';
import 'package:health_kit_reporter/model/payload/source.dart';
import 'package:health_kit_reporter/model/payload/source_revision.dart';
import 'package:health_kit_reporter/model/predicate.dart';

mixin HealthKitReporterMixin {
  Predicate get predicate => Predicate(
        DateTime.now().add(const Duration(days: -365)),
        DateTime.now(),
      );

  Device get device => const Device(
        'FlutterTracker',
        'kvs',
        'T-800',
        '3',
        '3.0',
        '1.1.1',
        'kvs.sample.app',
        '444-888-555',
      );

  Source get source => const Source(
        'myApp',
        'com.kvs.health_kit_reporter_example',
      );

  OperatingSystem get operatingSystem => const OperatingSystem(
        1,
        2,
        3,
      );

  SourceRevision get sourceRevision => SourceRevision(
        source,
        '5',
        'fit',
        '4',
        operatingSystem,
      );
}
