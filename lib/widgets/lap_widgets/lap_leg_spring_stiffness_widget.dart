import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_leg_spring_stiffness_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/models/event.dart';

class LapLegSpringStiffnessWidget extends StatefulWidget {
  const LapLegSpringStiffnessWidget({this.lap});

  final Lap lap;

  @override
  _LapLegSpringStiffnessWidgetState createState() =>
      _LapLegSpringStiffnessWidgetState();
}

class _LapLegSpringStiffnessWidgetState
    extends State<LapLegSpringStiffnessWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String sdevLegSpringStiffnessString = 'Loading ...';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(LapLegSpringStiffnessWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> legSpringStiffnessRecords = records
          .where((Event value) =>
              value.legSpringStiffness != null && value.legSpringStiffness > 0)
          .toList();

      if (legSpringStiffnessRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              LapLegSpringStiffnessChart(
                records: RecordList<Event>(legSpringStiffnessRecords),
              ),
              const Text(
                  'Only records where leg spring stiffness > 0 kN/m are shown.'),
              const Text('Swipe left/write to compare with other laps.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(
                    widget.lap.avgLegSpringStiffness.toStringOrDashes(1) +
                        ' ms'),
                subtitle: const Text('average ground time'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevLegSpringStiffnessString),
                subtitle: const Text('standard deviation ground time'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(legSpringStiffnessRecords.length.toString()),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No leg spring stiffness data available.'),
        );
      }
    } else {
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    final Lap lap = widget.lap;
    records = RecordList<Event>(await lap.records);
    final double sdev = await lap.sdevLegSpringStiffness;
    setState(() {
      sdevLegSpringStiffnessString = sdev.toStringOrDashes(2) + ' ms';
    });
  }
}
