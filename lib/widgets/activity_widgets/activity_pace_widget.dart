import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';

import 'package:encrateia/widgets/charts/activity_charts/activity_pace_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityPaceWidget extends StatefulWidget {
  const ActivityPaceWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityPaceWidgetState createState() => _ActivityPaceWidgetState();
}

class _ActivityPaceWidgetState extends State<ActivityPaceWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maximum = 50 / 3/ widget.activity.minSpeed;
    double minimum = 50 / 3/ widget.activity.maxSpeed;
    if (maximum>8) maximum = 8;

    if (records.isNotEmpty) {
      final List<Event> paceRecords = records
          .where((Event value) => value.speed != null && value.speed > 0)
          .toList();

      if (paceRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityPaceChart(
                records: RecordList<Event>(paceRecords),
                activity: widget.activity,
                athlete: widget.athlete,
                minimum: minimum,  // 50 / 3 / widget.activity.avgSpeed -3 * widget.activity.sdevPace,
                maximum: maximum, // 50 / 3 / widget.activity.avgSpeed + 3 * widget.activity.sdevPace,
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'speed > 0 m/s are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: PQText(value: widget.activity.avgPace, pq: PQ.pace),
                subtitle: const Text('average pace'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: PQText(
                  value: 50 / 3 / widget.activity.minSpeed,
                  pq: PQ.pace,
                ),
                subtitle: const Text('minimum pace'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: PQText(
                  value:  50 / 3 / widget.activity.maxSpeed,
                  pq: PQ.pace,
                ),
                subtitle: const Text('maximum pace'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(value: widget.activity.sdevPace, pq: PQ.pace),
                subtitle: const Text('standard deviation pace'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: paceRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No pace data available.'),
        );
      }
    } else {
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    final Activity activity = widget.activity;
    records = RecordList<Event>(await activity.records);
    setState(() => loading = false);
  }
}
