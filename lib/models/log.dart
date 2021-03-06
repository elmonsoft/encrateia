import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

// to get something as close as possible to the current method name, use:
// StackTrace.current.toString()

class Log {
  Log({
    @required String message,
    @required String method,
    String comment,
  }) {
    _db = DbLog()
      ..comment = comment
      ..method = method
      ..message = message
      ..dateTime = DateTime.now();

    log(message, name: method);
  }
  Log._fromDb(this._db);

  DbLog _db;

  DateTime get dateTime => _db.dateTime;
  String get comment => _db.comment;
  String get message => _db.message;
  String get method => _db.method;
  int get id => _db?.id;

  @override
  String toString() => '< Log | $dateTime | $message >';

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  static Log exDb(DbLog db) => Log._fromDb(db);
}
