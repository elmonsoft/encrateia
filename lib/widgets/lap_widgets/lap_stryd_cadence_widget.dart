import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_stryd_cadence_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/models/event.dart';

class LapStrydCadenceWidget extends StatefulWidget {
  const LapStrydCadenceWidget({this.lap});

  final Lap lap;

  @override
  _LapStrydCadenceWidgetState createState() => _LapStrydCadenceWidgetState();
}

class _LapStrydCadenceWidgetState extends State<LapStrydCadenceWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(LapStrydCadenceWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> strydCadenceRecords = records
          .where((Event value) =>
              value.strydCadence != null && value.strydCadence > 0)
          .toList();

      if (strydCadenceRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              LapStrydCadenceChart(
                records: RecordList<Event>(strydCadenceRecords),
                minimum: widget.lap.avgStrydCadence * 2 / 1.25,
                maximum: widget.lap.avgStrydCadence * 2 * 1.25,
              ),
              const Text('Only records where cadence > 0 s/min are shown.'),
              const Text('Swipe left/write to compare with other laps.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: PQText(
                  value: widget.lap.avgStrydCadence,
                  pq: PQ.cadence,
                ),
                subtitle: const Text('average cadence'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                  value: widget.lap.sdevStrydCadence,
                  pq: PQ.cadence,
                ),
                subtitle: const Text('standard deviation cadence'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title:
                    PQText(value: strydCadenceRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No cadence data available.'),
        );
      }
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.lap.records);
    setState(() => loading = false);
  }
}
