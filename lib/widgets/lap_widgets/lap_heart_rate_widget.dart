import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_heart_rate_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapHeartRateWidget extends StatefulWidget {
  final Lap lap;

  LapHeartRateWidget({this.lap});

  @override
  _LapHeartRateWidgetState createState() => _LapHeartRateWidgetState();
}

class _LapHeartRateWidgetState extends State<LapHeartRateWidget> {
  List<Event> records = [];
  String avgHeartRateString = "Loading ...";
  String sdevHeartRateString = "Loading ...";
  HeartRateZoneSchema heartRateZoneSchema;
  List<HeartRateZone> heartRateZones;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var heartRateRecords = records
          .where(
              (value) => value.db.heartRate != null && value.db.heartRate > 0)
          .toList();

      if (heartRateRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              LapHeartRateChart(
                records: records,
                heartRateZones: heartRateZones,
              ),
              ListTile(
                leading: MyIcon.average,
                title: Text(Lap.avgHeartRate(records: records)),
                subtitle: Text("average heart rate"),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: Text(Lap.minHeartRate(records: records)),
                subtitle: Text("minimum heart rate"),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: Text(Lap.maxHeartRate(records: records)),
                subtitle: Text("maximum heart rate"),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(Lap.sdevHeartRate(records: records)),
                subtitle: Text("standard deviation heart rate"),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(heartRateRecords.length.toString()),
                subtitle: Text("number of measurements"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No heart rate data available."),
        );
      }
    } else {
      return Center(
        child: Text("Loading"),
      );
    }
  }

  getData() async {
    Lap lap = widget.lap;
    records = await lap.records;

    heartRateZoneSchema = await lap.getHeartRateZoneSchema();
    if (heartRateZoneSchema != null)
      heartRateZones = await heartRateZoneSchema.heartRateZones;
    else
      heartRateZones = [];
    setState(() {});
  }
}
