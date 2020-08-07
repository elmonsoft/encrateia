import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/map_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:encrateia/models/plot_point.dart';
import 'package:encrateia/utils/enums.dart';
import 'bar_zone.dart';
import 'heart_rate_zone.dart';
import 'heart_rate_zone_schema.dart';

class RecordList<E> extends DelegatingList<E> {
  RecordList(List<E> records)
      : _records = records as List<Event>,
        super(records);

  final List<Event> _records;

  // AVERAGES:
  // Power
  double avgPower() {
    final Iterable<int> powers = _records
        .where((Event record) =>
            record.power != null && record.power > 0 && record.power < 2000)
        .map((Event record) => record.power);
    return powers.isNotEmpty ? powers.mean() : -1;
  }

  double sdevPower() => _records
      .where((Event record) =>
          record.power != null && record.power > 0 && record.power < 2000)
      .map((Event record) => record.power)
      .sdev();

  int minPower() {
    final List<int> powers =
        _records.map((Event record) => record.power).nonZeros().cast<int>();
    return powers.isNotEmpty ? powers.min() as int : 0;
  }

  int maxPower() {
    final List<int> powers =
        _records.map((Event record) => record.power).nonZeros().cast<int>();
    return powers.isNotEmpty ? powers.max() as int : 0;
  }

  // Heart Rate
  int avgHeartRate() {
    final Iterable<int> heartRates = _records
        .where((Event record) =>
            record.heartRate != null &&
            record.heartRate > 0 &&
            record.heartRate < 2000)
        .map((Event record) => record.heartRate);

    return heartRates.isNotEmpty ? heartRates.mean().round() : -1;
  }

  double sdevHeartRate() => _records
      .where((Event record) =>
          record.heartRate != null &&
          record.heartRate > 0 &&
          record.heartRate < 2000)
      .map((Event record) => record.heartRate)
      .sdev();

  int minHeartRate() {
    final List<int> heartRates =
        _records.map((Event record) => record.heartRate).nonZeros().cast<int>();
    return heartRates.isNotEmpty ? heartRates.min() as int : 0;
  }

  int maxHeartRate() {
    final List<int> heartRates =
        _records.map((Event record) => record.heartRate).nonZeros().cast<int>();
    return heartRates.isNotEmpty ? heartRates.max() as int : 0;
  }

  // Speed
  double avgSpeedByMeasurements() {
    final List<double> speeds =
        _records.map((Event record) => record.speed).nonZeros().cast<double>();

    return speeds.isNotEmpty ? speeds.mean() : -1;
  }

  double avgSpeedBySpeed() {
    final Map<DateTime, double> speedMap = <DateTime, double>{
      for (final Event record in _records) record.timeStamp: record.speed
    };
    return speedMap.meanBySpeed();
  }

  double avgSpeedByDistance() {
    final Map<DateTime, double> speedMap = <DateTime, double>{
      for (final Event record in _records) record.timeStamp: record.distance,
    };
    return speedMap.meanByDistance();
  }

  double sdevSpeed() => _records
      .where((Event record) => record.speed != null)
      .map((Event record) => record.speed)
      .sdev();

  double sdevPace() => _records
      .where((Event record) => record.speed != null && record.speed > 1)
      .map((Event record) => 50 / 3 / record.speed)
      .sdev();

  double minSpeed() {
    final List<double> speeds =
        _records.map((Event record) => record.speed).nonZeros().cast<double>();
    return speeds.isNotEmpty ? speeds.min() as double : 0;
  }

  double maxSpeed() {
    final List<double> speeds =
        _records.map((Event record) => record.speed).nonZeros().cast<double>();
    return speeds.isNotEmpty ? speeds.max() as double : 0;
  }

  // Ground Time
  double avgGroundTime() {
    final List<double> groundTimes = _records
        .map((Event record) => record.groundTime)
        .nonZeros()
        .cast<double>();

    return groundTimes.isNotEmpty ? groundTimes.mean() : -1;
  }

  double sdevGroundTime() =>
      _records.map((Event record) => record.groundTime).nonZeros().sdev();

  double minGroundTime() {
    final List<double> groundTimes = _records
        .map((Event record) => record.groundTime)
        .nonZeros()
        .cast<double>();
    return groundTimes.isNotEmpty ? groundTimes.min() as double : 0;
  }

  double maxGroundTime() {
    final List<double> groundTimes = _records
        .map((Event record) => record.groundTime)
        .nonZeros()
        .cast<double>();
    return groundTimes.isNotEmpty ? groundTimes.max() as double : 0;
  }

  // Stryd Cadence
  double avgStrydCadence() {
    final List<double> strydCadences = _records
        .map((Event record) => record.strydCadence ?? 0.0 * 2)
        .nonZeros()
        .cast<double>();
    return strydCadences.isNotEmpty ? strydCadences.mean() : -1;
  }

  double sdevStrydCadence() => _records
      .map((Event record) => record.strydCadence ?? 0.0 * 2)
      .nonZeros()
      .sdev();

  double minStrydCadence() {
    final List<double> strydCadences = _records
        .map((Event record) => record.strydCadence)
        .nonZeros()
        .cast<double>();
    return strydCadences.isNotEmpty ? strydCadences.min() as double : 0;
  }

  double maxStrydCadence() {
    final List<double> strydCadences = _records
        .map((Event record) => record.strydCadence)
        .nonZeros()
        .cast<double>();
    return strydCadences.isNotEmpty ? strydCadences.max() as double : 0;
  }

  // Cadence
  double avgCadence() {
    final List<double> cadences = _records
        .map((Event record) => record.cadence ?? 0.0 * 2)
        .nonZeros()
        .cast<double>();
    return cadences.isNotEmpty ? cadences.mean() : -1;
  }

  double sdevCadence() => _records
      .map((Event record) => record.cadence ?? 0.0 * 2)
      .nonZeros()
      .sdev();

  double minCadence() {
    final List<double> cadences = _records
        .map((Event record) => record.cadence)
        .nonZeros()
        .cast<double>();
    return cadences.isNotEmpty ? cadences.min() as double : 0;
  }

  double maxCadence() {
    final List<double> cadences = _records
        .map((Event record) => record.cadence)
        .nonZeros()
        .cast<double>();
    return cadences.isNotEmpty ? cadences.max() as double : 0;
  }

  // Leg Spring Stiffness
  double avgLegSpringStiffness() {
    final List<double> legSpringStiffnesses = _records
        .map((Event record) => record.legSpringStiffness)
        .nonZeros()
        .cast<double>();
    return legSpringStiffnesses.isNotEmpty ? legSpringStiffnesses.mean() : -1;
  }

  double sdevLegSpringStiffness() => _records
      .map((Event record) => record.legSpringStiffness)
      .nonZeros()
      .sdev();

  double minLegSpringStiffness() {
    final List<double> legSpringStiffnesses = _records
        .map((Event record) => record.legSpringStiffness)
        .nonZeros()
        .cast<double>();
    return legSpringStiffnesses.isNotEmpty
        ? legSpringStiffnesses.min() as double
        : 0;
  }

  double maxLegSpringStiffness() {
    final List<double> legSpringStiffnesses = _records
        .map((Event record) => record.legSpringStiffness)
        .nonZeros()
        .cast<double>();
    return legSpringStiffnesses.isNotEmpty
        ? legSpringStiffnesses.max() as double
        : 0;
  }

  // Vertical Oscillation
  double avgVerticalOscillation() {
    final List<double> verticalOscillation = _records
        .map((Event record) => record.verticalOscillation)
        .nonZeros()
        .cast<double>();
    return verticalOscillation.isNotEmpty ? verticalOscillation.mean() : -1;
  }

  double sdevVerticalOscillation() => _records
      .map((Event record) => record.verticalOscillation)
      .nonZeros()
      .sdev();

  double minVerticalOscillation() {
    final List<double> verticalOscillations = _records
        .map((Event record) => record.verticalOscillation)
        .nonZeros()
        .cast<double>();
    return verticalOscillations.isNotEmpty
        ? verticalOscillations.min() as double
        : 0;
  }

  double maxVerticalOscillation() {
    final List<double> verticalOscillations = _records
        .map((Event record) => record.verticalOscillation)
        .nonZeros()
        .cast<double>();
    return verticalOscillations.isNotEmpty
        ? verticalOscillations.max() as double
        : 0;
  }

  // Form Power
  double avgFormPower() {
    final Iterable<int> formPowers = _records
        .where((Event record) =>
            record.formPower != null && record.formPower < 200)
        .map((Event record) => record.formPower);
    return formPowers.isNotEmpty ? formPowers.mean() : -1;
  }

  double sdevFormPower() => _records
      .where(
          (Event record) => record.formPower != null && record.formPower < 200)
      .map((Event record) => record.formPower)
      .sdev();

  int minFormPower() {
    final List<int> formPowers =
        _records.map((Event record) => record.formPower).nonZeros().cast<int>();
    return formPowers.isNotEmpty ? formPowers.min() as int : 0;
  }

  int maxFormPower() {
    final List<int> formPowers =
        _records.map((Event record) => record.formPower).nonZeros().cast<int>();
    return formPowers.isNotEmpty ? formPowers.max() as int : 0;
  }

  // Power Ratio
  double avgPowerRatio() {
    final Iterable<double> powerRatios = _records
        .where((Event record) =>
            record.power != null &&
            record.power != 0 &&
            record.formPower != null &&
            record.formPower != 0)
        .map((Event record) =>
            (record.power - record.formPower) / record.power * 100);

    return powerRatios.isNotEmpty ? powerRatios.mean() : -1;
  }

  double sdevPowerRatio() => _records
      .where((Event record) =>
          record.power != null &&
          record.power != 0 &&
          record.formPower != null &&
          record.formPower != 0)
      .map((Event record) =>
          (record.power - record.formPower) / record.power * 100)
      .sdev();

  // Stride Ratio
  double avgStrideRatio() {
    final Iterable<double> powerRatios = _records
        .where((Event record) =>
            record.speed != null &&
            record.strydCadence != null &&
            record.strydCadence != 0 &&
            record.verticalOscillation != null &&
            record.verticalOscillation != 0)
        .map((Event record) =>
            10000 /
            6 *
            record.speed /
            record.strydCadence /
            record.verticalOscillation);

    return powerRatios.isNotEmpty ? powerRatios.mean() : -1;
  }

  double sdevStrideRatio() => _records
      .where((Event record) =>
          record.speed != null &&
          record.strydCadence != null &&
          record.strydCadence != 0 &&
          record.verticalOscillation != null &&
          record.verticalOscillation != 0)
      .map((Event record) =>
          10000 /
          6 *
          record.speed /
          record.strydCadence /
          record.verticalOscillation)
      .sdev();

  // Ascend and descend
  double totalAscent() {
    double lastAltitude = 0;
    double sumOfAscents = 0;
    final List<double> altitudes = _records
        .map((Event record) => record.altitude)
        .nonZeros()
        .cast<double>();

    for (final double altitude in altitudes) {
      if (lastAltitude != 0 && altitude > lastAltitude)
        sumOfAscents += altitude - lastAltitude;
      lastAltitude = altitude;
    }
    return sumOfAscents;
  }

  double totalDescent() {
    double lastAltitude = 0;
    double sumOfDescents = 0;
    final List<double> altitudes = _records
        .map((Event record) => record.altitude)
        .nonZeros()
        .cast<double>();

    for (final double altitude in altitudes) {
      if (lastAltitude != 0 && altitude < lastAltitude)
        sumOfDescents += lastAltitude - altitude;
      lastAltitude = altitude;
    }
    return sumOfDescents;
  }

  // END OF AVERAGES

  List<IntPlotPoint> toIntDataPoints({
    int amount,
    @required LapIntAttr attribute,
  }) {
    int index = 0;
    final List<IntPlotPoint> plotPoints = <IntPlotPoint>[];
    int sum = 0;

    for (final Event record in _records) {
      switch (attribute) {
        case LapIntAttr.power:
          sum += record.power;
          break;
        case LapIntAttr.formPower:
          sum += record.formPower;
          break;
        case LapIntAttr.heartRate:
          sum += record.heartRate;
      }

      if (index++ % amount == amount - 1) {
        plotPoints.add(IntPlotPoint(
          domain: record.distance.round(),
          measure: (sum / amount).round(),
        ));
        sum = 0;
      }
    }
    return plotPoints;
  }

  List<DoublePlotPoint> toDoubleDataPoints({
    int amount,
    @required LapDoubleAttr attribute,
    double weight,
  }) {
    int index = 0;
    final List<DoublePlotPoint> plotPoints = <DoublePlotPoint>[];
    double sum = 0.0;

    for (final Event record in _records) {
      switch (attribute) {
        case LapDoubleAttr.powerPerHeartRate:
          sum = sum + (record.power / record.heartRate);
          break;
        case LapDoubleAttr.speedPerHeartRate:
          sum = sum + 100 * (record.speed / record.heartRate);
          break;
        case LapDoubleAttr.groundTime:
          sum = sum + record.groundTime;
          break;
        case LapDoubleAttr.strydCadence:
          sum = sum + 2 * record.strydCadence;
          break;
        case LapDoubleAttr.verticalOscillation:
          sum = sum + record.verticalOscillation;
          break;
        case LapDoubleAttr.legSpringStiffness:
          sum = sum + record.legSpringStiffness;
          break;
        case LapDoubleAttr.powerRatio:
          sum = sum + ((record.power - record.formPower) / record.power * 100);
          break;
        case LapDoubleAttr.strideRatio:
          sum = sum +
              (10000 /
                  6 *
                  record.speed /
                  record.strydCadence /
                  record.verticalOscillation);
          break;
        case LapDoubleAttr.ecor:
          sum = sum + (record.power / record.speed / weight);
          break;
        case LapDoubleAttr.pace:
          sum = sum + (50 / 3 / record.speed);
          break;
        case LapDoubleAttr.speed:
          sum = sum + record.speed * 3.6;
          break;
        case LapDoubleAttr.altitude:
          sum = sum + record.altitude;
      }

      if (index++ % amount == amount - 1) {
        plotPoints.add(DoublePlotPoint(
          domain: record.distance.round(),
          measure: sum / amount,
        ));
        sum = 0;
      }
    }
    return plotPoints;
  }

  Future<List<BarZone>> powerZoneCounts(
      {PowerZoneSchema powerZoneSchema}) async {
    final List<BarZone> distributions = <BarZone>[];
    double counter = 0.0;

    final List<PowerZone> powerZones = await powerZoneSchema.powerZones;

    for (final PowerZone powerZone in powerZones) {
      final int numberInZone = _records
          .where((Event event) =>
              (event.power >= powerZone.lowerLimit) &&
              (event.power <= powerZone.upperLimit))
          .length;
      distributions.add(BarZone(
        lower: counter,
        upper: counter + numberInZone,
        color: powerZone.color,
      ));
      counter = counter + numberInZone;
    }
    return distributions;
  }

  Future<List<BarZone>> heartRateZoneCounts(
      {HeartRateZoneSchema heartRateZoneSchema}) async {
    final List<BarZone> distributions = <BarZone>[];
    double counter = 0.0;

    final List<HeartRateZone> heartRateZones =
        await heartRateZoneSchema.heartRateZones;

    for (final HeartRateZone heartRateZone in heartRateZones) {
      final int numberInZone = _records
          .where((Event event) =>
              (event.heartRate >= heartRateZone.lowerLimit) &&
              (event.heartRate <= heartRateZone.upperLimit))
          .length;
      distributions.add(BarZone(
        lower: counter,
        upper: counter + numberInZone,
        color: heartRateZone.color,
      ));
      counter = counter + numberInZone;
    }
    return distributions;
  }
}
