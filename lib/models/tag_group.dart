import 'package:encrateia/models/tag.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart'
    show DbActivityTagging, DbLapTagging, DbTag, DbTagGroup;
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart' show BoolResult;
import 'lap.dart';

class TagGroup {
  TagGroup({@required Athlete athlete}) {
    _db = DbTagGroup()
      ..athletesId = athlete.id
      ..color = Colors.lightGreen.value
      ..system = false
      ..name = 'My Tag Group';
  }

  TagGroup._fromDb(this._db);

  TagGroup.by(
      {@required Athlete athlete,
      @required String name,
      @required bool system,
      @required int color}) {
    _db = DbTagGroup()
      ..athletesId = athlete.id
      ..color = color
      ..system = system
      ..name = name;
  }

  DbTagGroup _db;
  List<Tag> cachedTags;

  int get id => _db?.id;
  String get name => _db.name;
  bool get system => _db.system;
  int get color => _db.color;

  set color(int value) => _db.color = value;
  set name(String value) => _db.name = value;

  Future<List<Tag>> get tags async {
    final List<DbTag> dbTags =
        await _db.getDbTags().orderBy('sortOrder').orderBy('name').toList();
    return dbTags.map(Tag.exDb).toList();
  }

  @override
  String toString() => '< TagGroup | $name >';

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  static Future<TagGroup> autoPowerTagGroup({@required Athlete athlete}) async {
    final DbTagGroup dbTagGroup = await DbTagGroup()
        .select()
        .system
        .equals(true)
        .and
        .athletesId
        .equals(athlete.id)
        .and
        .name
        .equals('Auto Power Zones')
        .toSingle();
    if (dbTagGroup != null)
      return TagGroup._fromDb(dbTagGroup);
    else {
      final TagGroup autoPowerTagGroup = TagGroup.by(
        name: 'Auto Power Zones',
        athlete: athlete,
        system: true,
        color: MyColor.bitterSweet.value,
      );
      await autoPowerTagGroup._db.save();
      return autoPowerTagGroup;
    }
  }

  static Future<TagGroup> autoHeartRateTagGroup(
      {@required Athlete athlete}) async {
    final DbTagGroup dbTagGroup = await DbTagGroup()
        .select()
        .system
        .equals(true)
        .and
        .athletesId
        .equals(athlete.id)
        .and
        .name
        .equals('Auto Heart Rate Zones')
        .toSingle();
    if (dbTagGroup != null)
      return TagGroup._fromDb(dbTagGroup);
    else {
      final TagGroup autoHeartRateTagGroup = TagGroup.by(
        name: 'Auto Heart Rate Zones',
        athlete: athlete,
        system: true,
        color: MyColor.grapeFruit.value,
      );
      await autoHeartRateTagGroup._db.save();
      return autoHeartRateTagGroup;
    }
  }

  static Future<TagGroup> autoEffortTagGroup(
      {@required Athlete athlete}) async {
    final DbTagGroup dbTagGroup = await DbTagGroup()
        .select()
        .athletesId
        .equals(athlete.id)
        .and
        .name
        .equals('Effort')
        .toSingle();
    if (dbTagGroup != null)
      return TagGroup._fromDb(dbTagGroup);
    else {
      final TagGroup autoEffortTagGroup = TagGroup.by(
        name: 'Effort',
        athlete: athlete,
        system: false,
        color: MyColor.brightGoldenYellow.value,
      );
      await autoEffortTagGroup._db.save();
      return autoEffortTagGroup;
    }
  }

  static Future<TagGroup> autoMaxPowerTagGroup(
      {@required Athlete athlete}) async {
    final DbTagGroup dbTagGroup = await DbTagGroup()
        .select()
        .system
        .equals(true)
        .and
        .athletesId
        .equals(athlete.id)
        .and
        .name
        .equals('Auto Power Max Zone')
        .toSingle();
    if (dbTagGroup != null) {
      return TagGroup._fromDb(dbTagGroup);
    } else {
      final TagGroup autoMaxPowerTagGroup = TagGroup.by(
        name: 'Auto Power Max Zone',
        athlete: athlete,
        system: true,
        color: MyColor.bitterSweet.value,
      );
      await autoMaxPowerTagGroup._db.save();
      return autoMaxPowerTagGroup;
    }
  }

  static Future<TagGroup> autoMaxHeartRateTagGroup(
      {@required Athlete athlete}) async {
    final DbTagGroup dbTagGroup = await DbTagGroup()
        .select()
        .system
        .equals(true)
        .and
        .athletesId
        .equals(athlete.id)
        .and
        .name
        .equals('Auto Heart Rate Max Zone')
        .toSingle();
    if (dbTagGroup != null) {
      return TagGroup._fromDb(dbTagGroup);
    } else {
      final TagGroup autoMaxHeartRateTagGroup = TagGroup.by(
        name: 'Auto Heart Rate Max Zone',
        athlete: athlete,
        system: true,
        color: MyColor.grapeFruit.value,
      );
      await autoMaxHeartRateTagGroup._db.save();
      return autoMaxHeartRateTagGroup;
    }
  }

  static Future<TagGroup> autoSportTagGroup({@required Athlete athlete}) async {
    final DbTagGroup dbTagGroup = await DbTagGroup()
        .select()
        .system
        .equals(true)
        .and
        .athletesId
        .equals(athlete.id)
        .and
        .name
        .equals('Auto Sport/Activity')
        .toSingle();
    if (dbTagGroup != null) {
      //await TagGroup._fromDb(dbTagGroup)._db.delete();
      return TagGroup._fromDb(dbTagGroup);
    } else {
      final TagGroup autoSportTagGroup = TagGroup.by(
        name: 'Auto Sport/Activity',
        athlete: athlete,
        system: true,
        color: MyColor.sunFlowerAccent.value,
      );
      await autoSportTagGroup._db.save();
      return autoSportTagGroup;
    }
  }

  static Future<List<TagGroup>> includingActivityTaggings({
    @required Athlete athlete,
    @required Activity activity,
  }) async {
    final List<TagGroup> tagGroups = await athlete.tagGroups;

    final List<DbActivityTagging> dbActivityTaggings = await DbActivityTagging()
        .select()
        .activitiesId
        .equals(activity.id)
        .toList();
    final Iterable<int> selectedTagIds = dbActivityTaggings
        .map((DbActivityTagging dbActivityTagging) => dbActivityTagging.tagsId);

    for (final TagGroup tagGroup in tagGroups) {
      tagGroup.cachedTags = await tagGroup.tags;
      for (final Tag tag in tagGroup.cachedTags) {
        tag.selected = selectedTagIds.contains(tag.id);
      }
    }
    return tagGroups;
  }

  static Future<List<TagGroup>> includingLapTaggings({
    @required Athlete athlete,
    @required Lap lap,
  }) async {
    final List<TagGroup> tagGroups = await athlete.tagGroups;

    final List<DbLapTagging> dbLapTaggings =
        await DbLapTagging().select().lapsId.equals(lap.id).toList();

    final Iterable<int> selectedTagIds =
        dbLapTaggings.map((DbLapTagging dbLapTagging) => dbLapTagging.tagsId);

    for (final TagGroup tagGroup in tagGroups) {
      tagGroup.cachedTags = await tagGroup.tags;
      for (final Tag tag in tagGroup.cachedTags) {
        tag.selected = selectedTagIds.contains(tag.id);
      }
    }
    return tagGroups;
  }

  static Future<List<TagGroup>> allByAthlete({Athlete athlete}) async {
    final List<DbTagGroup> dbTagGroups =
        await DbTagGroup().select().athletesId.equals(athlete.id).toList();
    return dbTagGroups.map(TagGroup.exDb).toList();
  }

  static Future<void> deleteAllAutoTags({Athlete athlete}) async {
    final TagGroup autoHeartRateTagGroup =
        await TagGroup.autoHeartRateTagGroup(athlete: athlete);
    await autoHeartRateTagGroup._db.getDbTags().delete();

    final TagGroup autoMaxHeartRateTagGroup =
        await TagGroup.autoMaxHeartRateTagGroup(athlete: athlete);
    await autoMaxHeartRateTagGroup._db.getDbTags().delete();

    final TagGroup autoPowerTagGroup =
        await TagGroup.autoPowerTagGroup(athlete: athlete);
    await autoPowerTagGroup._db.getDbTags().delete();

    final TagGroup autoMaxPowerTagGroup =
        await TagGroup.autoMaxPowerTagGroup(athlete: athlete);
    await autoMaxPowerTagGroup._db.getDbTags().delete();

    final TagGroup autoSportTagGroup =
        await TagGroup.autoSportTagGroup(athlete: athlete);
    await autoSportTagGroup._db.getDbTags().delete();
  }

  static TagGroup exDb(DbTagGroup db) => TagGroup._fromDb(db);
}
