import 'package:encrateia/widgets/charts/actitvity_charts/activity_power_per_heart_rate_chart.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityPowerPerHeartRateWidget extends StatefulWidget {
  final Activity activity;

  ActivityPowerPerHeartRateWidget({this.activity});

  @override
  _ActivityPowerPerHeartRateWidgetState createState() =>
      _ActivityPowerPerHeartRateWidgetState();
}

class _ActivityPowerPerHeartRateWidgetState
    extends State<ActivityPowerPerHeartRateWidget> {
  List<Event> records = [];
  String avgPowerPerHeartRateString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var powerValues = records.map((value) => value.db.power).nonZeroInts();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityPowerPerHeartRateChart(
                records: records,
                activity: widget.activity,
              ),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgPowerPerHeartRateString),
                subtitle: Text("average power per heart rate"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No power per heart rate data available."),
        );
      }
    } else {
      return Center(
        child: Text("Loading"),
      );
    }
  }

  getData() async {
    Activity activity = widget.activity;
    records = await activity.records;

    double avg = await activity.avgPower / activity.db.avgHeartRate;
    setState(() {
      avgPowerPerHeartRateString = avg.toStringOrDashes(1) + " W / bpm";
    });
  }
}