import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_altitude_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityAltitudeWidget extends StatefulWidget {
  const ActivityAltitudeWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityAltitudeWidgetState createState() => _ActivityAltitudeWidgetState();
}

class _ActivityAltitudeWidgetState extends State<ActivityAltitudeWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> altitudeRecords =
          records.where((Event value) => value.altitude != null).toList();

      if (altitudeRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityAltitudeChart(
                records: RecordList<Event>(altitudeRecords),
                activity: widget.activity,
                athlete: widget.athlete,
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records with '
                  'altitude measurements are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: records.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No altitude data available.'),
        );
      }
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'no records found'),
      );
    }
  }

  Future<void> getData() async {
    final Activity activity = widget.activity;
    records = RecordList<Event>(await activity.records);
    setState(() => loading = false);
  }
}
