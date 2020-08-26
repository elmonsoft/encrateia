import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/screens/show_lap_screen.dart';

class LapsListSimpleWidget extends StatefulWidget {
  const LapsListSimpleWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _LapsListSimpleWidgetState createState() => _LapsListSimpleWidgetState();
}

class _LapsListSimpleWidgetState extends State<LapsListSimpleWidget> {
  List<Lap> laps = <Lap>[];
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (laps.isNotEmpty) {
      return SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            showCheckboxColumn: false,
            onSelectAll: (_) {},
            columns: const <DataColumn>[
              DataColumn(label: Text('Lap'), numeric: true),
              DataColumn(label: Text('Time'), numeric: true),
              DataColumn(label: Text('Dist.\nkm'), numeric: true),
              DataColumn(label: Text('Ascent\nm'), numeric: true),
              DataColumn(label: Text('Pace\nmin/km'), numeric: true),
              DataColumn(label: Text('HR\nbpm'), numeric: true),
              DataColumn(label: Text('Power\nWatt'), numeric: true),
            ],
            rows: laps.map((Lap lap) {
              lap.lm.dzeit = double.parse(lap.totalElapsedTime.toString());
              return DataRow(
                key: ValueKey<int>(lap.id),
                onSelectChanged: (bool selected) {
                  if (selected) {
                    Navigator.push(
                      context,
                      MaterialPageRoute<BuildContext>(
                        builder: (BuildContext context) => ShowLapScreen(
                          lap: lap,
                          laps: laps,
                          athlete: widget.athlete,
                        ),
                      ),
                    );
                  }
                },
                cells: <DataCell>[
                  DataCell(PQText(value: lap.index, pq: PQ.integer)),
                  DataCell(Text(lap.lm.zeit)),
                  DataCell(
                      PQText(value: lap.totalDistance, pq: PQ.distance)),
                  DataCell(
                    PQText(
                      value: (lap.totalAscent ?? 0) - (lap.totalDescent ?? 0),
                      pq: PQ.elevation,
                    )),
                  DataCell(PQText(value: lap.avgSpeed, pq: PQ.paceFromSpeed)),
                  DataCell(PQText(value: lap.avgHeartRate, pq: PQ.heartRate)),
                  DataCell(PQText(value: lap.avgPower, pq: PQ.power)),
                ],
              );
            }).toList(),
          ),
        ),
      );
    } else
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
  }

  Future<void> getData() async {
    laps = await widget.activity.laps;
    setState(() => loading = false);
  }
}
