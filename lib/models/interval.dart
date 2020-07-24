import 'package:encrateia/model/model.dart' show DbEvent, DbInterval;
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/activity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class Interval {
  Interval() {
    _db = DbInterval();
  }

  Interval._fromDb(this._db);

  DbInterval _db;
  Activity activity;
  List<Event> _records = <Event>[];

  int get id => _db?.id;
  DateTime get timeStamp => _db.timeStamp;

  double get avgCadence => _db.avgCadence;
  double get avgFormPower => _db.avgFormPower;
  double get avgGroundTime => _db.avgGroundTime;
  double get avgLegSpringStiffness => _db.avgLegSpringStiffness;
  double get avgPower => _db.avgPower;
  double get avgSpeed => _db.avgSpeed;
  double get avgStrydCadence => _db.avgStrydCadence;
  double get avgVerticalOscillation => _db.avgVerticalOscillation;
  double get cp => _db.cp;
  double get ftp => _db.ftp;
  double get maxCadence => _db.maxCadence;
  double get maxGroundTime => _db.maxGroundTime;
  double get maxLegSpringStiffness => _db.maxLegSpringStiffness;
  double get maxSpeed => _db.maxSpeed;
  double get maxStrydCadence => _db.maxStrydCadence;
  double get maxVerticalOscillation => _db.maxVerticalOscillation;
  double get minCadence => _db.minCadence;
  double get minGroundTime => _db.minGroundTime;
  double get minLegSpringStiffness => _db.minLegSpringStiffness;
  double get minSpeed => _db.minSpeed;
  double get minStrydCadence => _db.minStrydCadence;
  double get minVerticalOscillation => _db.minVerticalOscillation;
  double get sdevCadence => _db.sdevCadence;
  double get sdevFormPower => _db.sdevFormPower;
  double get sdevGroundTime => _db.sdevGroundTime;
  double get sdevHeartRate => _db.sdevHeartRate;
  double get sdevLegSpringStiffness => _db.sdevLegSpringStiffness;
  double get sdevPace => _db.sdevPace;
  double get sdevPower => _db.sdevPower;
  double get sdevSpeed => _db.sdevSpeed;
  double get sdevStrydCadence => _db.sdevStrydCadence;
  double get sdevVerticalOscillation => _db.sdevVerticalOscillation;
  int get activitiesId => _db.activitiesId;
  int get athletesId => _db.athletesId;
  int get firstRecordId => _db.firstRecordId;
  int get lastRecordId => _db.lastRecordId;
  int get avgHeartRate => _db.avgHeartRate;
  int get distance => _db.distance;
  int get duration => _db.duration;
  int get maxFormPower => _db.maxFormPower;
  int get maxHeartRate => _db.maxHeartRate;
  int get maxPower => _db.maxPower;
  int get minFormPower => _db.minFormPower;
  int get minHeartRate => _db.minHeartRate;
  int get minPower => _db.minPower;
  int get totalAscent => _db.totalAscent;
  int get totalDescent => _db.totalDescent;

  set firstRecordId(int value) => _db.firstRecordId = value;
  set lastRecordId(int value) => _db.lastRecordId = value;

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  Future<void> setAverages() async {
    final RecordList<Event> recordList = RecordList<Event>(await records);
    _db
      ..avgPower = recordList.avgPower()
      ..sdevPower = recordList.sdevPower()
      ..minPower = recordList.minPower()
      ..maxPower = recordList.maxPower()
      ..avgHeartRate = recordList.avgHeartRate()
      ..sdevHeartRate = recordList.sdevHeartRate()
      ..minHeartRate = recordList.minHeartRate()
      ..maxHeartRate = recordList.maxHeartRate()
      ..avgSpeed = recordList.avgSpeed()
      ..sdevSpeed = recordList.sdevSpeed()
      ..sdevPace = recordList.sdevPace()
      ..minSpeed = recordList.minSpeed()
      ..maxSpeed = recordList.maxSpeed()
      ..avgGroundTime = recordList.avgGroundTime()
      ..sdevGroundTime = recordList.sdevGroundTime()
      ..avgStrydCadence = recordList.avgStrydCadence()
      ..sdevStrydCadence = recordList.sdevStrydCadence()
      ..avgLegSpringStiffness = recordList.avgLegSpringStiffness()
      ..sdevLegSpringStiffness = recordList.sdevLegSpringStiffness()
      ..avgVerticalOscillation = recordList.avgVerticalOscillation()
      ..sdevVerticalOscillation = recordList.sdevVerticalOscillation()
      ..avgFormPower = recordList.avgFormPower()
      ..sdevFormPower = recordList.sdevFormPower();
    await save();
  }

  Future<List<Event>> get records async {
    final List<DbEvent> dbEvents = await DbEvent()
        .select()
        .id
        .greaterThanOrEquals(firstRecordId)
        .and
        .id
        .lessThanOrEquals(lastRecordId)
        .toList();
    final List<Event> events = dbEvents.map(Event.exDb).toList();
    _records = events.where((Event event) => event.event == 'record').toList();
    return _records;
  }

  static Interval exDb(DbInterval db) => Interval._fromDb(db);
}
