import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/widgets/charts/athlete_charts/athlete_power_ratio_chart.dart';

class AthletePowerRatioWidget extends StatefulWidget {
  final Athlete athlete;

  AthletePowerRatioWidget({this.athlete});

  @override
  _AthletePowerRatioWidgetState createState() => _AthletePowerRatioWidgetState();
}

class _AthletePowerRatioWidgetState extends State<AthletePowerRatioWidget> {
  List<Activity> activities = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (activities.length > 0) {
      var powerValues = activities.map((value) => value.db.avgPower).nonZeroDoubles();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              AthletePowerRatioChart(activities: activities),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No power ratio data available."),
        );
      }
    } else {
      return Center(
        child: Text("Loading"),
      );
    }
  }

  getData() async {
    Athlete athlete = widget.athlete;
    activities = await athlete.activities;
    setState(() {});
  }
}
