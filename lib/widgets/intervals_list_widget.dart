import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/screens/select_interval_screen.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/screens/show_lap_screen.dart';

class IntervalsListWidget extends StatefulWidget {
  const IntervalsListWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _IntervalsListWidgetState createState() => _IntervalsListWidgetState();
}

class _IntervalsListWidgetState extends State<IntervalsListWidget> {
  List<encrateia.Interval> intervals = <encrateia.Interval>[];
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (intervals.isNotEmpty)
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyButton.add(
              child: const Text('Specify an Interval'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<BuildContext>(
                  builder: (BuildContext context) => SelectIntervalScreen(
                    athlete: widget.athlete,
                    activity: widget.activity,
                  ),
                ),
              ),
            ),
            DataTable(
              showCheckboxColumn: false,
              onSelectAll: (_) {},
              columns: const <DataColumn>[
                DataColumn(label: Text('Lap'), numeric: true),
                DataColumn(label: Text('HR\nbpm'), numeric: true),
                DataColumn(label: Text('Pace\nmin:s'), numeric: true),
                DataColumn(label: Text('Power\nWatt'), numeric: true),
                DataColumn(label: Text('Dist.\nm'), numeric: true),
                DataColumn(label: Text('Ascent\nm'), numeric: true),
              ],
              rows: intervals.map((encrateia.Interval interval) {
                return DataRow(
                  key: ValueKey<int>(interval.id),
                  onSelectChanged: (bool selected) {
                    if (selected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute<BuildContext>(
                          builder: (BuildContext context) => ShowLapScreen(
                            lap: null,
                            laps: null,
                            athlete: widget.athlete,
                          ),
                        ),
                      );
                    }
                  },
                  cells: <DataCell>[
                    DataCell(PQText(value: interval.index, pq: PQ.integer)),
                    DataCell(PQText(
                      value: interval.avgHeartRate,
                      pq: PQ.heartRate,
                    )),
                    DataCell(PQText(
                      value: interval.avgSpeed,
                      pq: PQ.paceFromSpeed,
                    )),
                    DataCell(PQText(value: interval.avgPower, pq: PQ.power)),
                    DataCell(PQText(value: interval.distance, pq: PQ.distance)),
                    DataCell(
                      PQText(
                        value: (interval.totalAscent ?? 0) -
                            (interval.totalDescent ?? 0),
                        pq: PQ.elevation,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      );
    else
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
  }

  Future<void> getData() async {
    intervals = await widget.activity.intervals;
    setState(() => loading = false);
  }
}
