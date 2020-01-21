import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/screens/show_lap_screen.dart';
import 'package:encrateia/utils/date_time_utils.dart';

class LapsListWidget extends StatelessWidget {
  final Activity activity;

  LapsListWidget({this.activity});

  @override
  Widget build(context) {
    return FutureBuilder<List<Lap>>(
      future: Lap.by(activity: activity),
      builder: (BuildContext context, AsyncSnapshot<List<Lap>> snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            dataRowHeight: kMinInteractiveDimension * 0.60,
            columnSpacing: 20,
            columns: <DataColumn>[
              const DataColumn(
                label: Icon(Icons.loop),
                tooltip: 'Lap',
                numeric: true,
              ),
              const DataColumn(
                label: Text("bpm"),
                tooltip: 'heartrate',
                numeric: true,
              ),
              const DataColumn(
                label: Text("min:ss"),
                tooltip: 'pace',
                numeric: true,
              ),
              const DataColumn(
                label: Icon(Icons.swap_calls),
                tooltip: 'distance',
                numeric: true,
              ),
              const DataColumn(
                label: Icon(Icons.trending_up),
                tooltip: 'ascent',
                numeric: true,
              ),
            ],
            rows: snapshot.data.map((Lap lap) {
              return DataRow(
                key: Key(lap.db.id.toString()),
                onSelectChanged: (bool selected) {
                  if (selected) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowLapScreen(lap: lap),
                      ),
                    );
                  }
                },
                cells: [
                  DataCell(
                    Text(lap.index.toString()),
                  ),
                  DataCell(
                    Text(lap.db.avgHeartRate.toString()),
                  ),
                  DataCell(
                    Text(lap.db.avgSpeed.toPace()),
                  ),
                  DataCell(
                    Text((lap.db.totalDistance / 1000).toStringAsFixed(2) +
                        ' km'),
                  ),
                  DataCell(
                    Text((lap.db.totalAscent - lap.db.totalDescent).toString()),
                  ),
                ],
              );
            }).toList(),
          );
        } else {
          return Center(
            child: Text("Loading"),
          );
        }
      },
    );
  }
}