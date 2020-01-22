import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'lap_heart_rate_chart.dart';

class LapHeartRateWidget extends StatelessWidget {
  final Lap lap;

  LapHeartRateWidget({this.lap});

  @override
  Widget build(context) {
    return FutureBuilder<List<Event>>(
      future: Event.recordsByLap(lap: lap),
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.hasData) {
          var heartRates =
              snapshot.data.map((value) => value.db.heartRate).nonZero();
          if (heartRates.length > 0) {
            var records = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                LapHeartRateChart(records: records),
                Expanded(
                  child: ListTileTheme(
                    iconColor: Colors.lightGreen,
                    child: ListView(
                      padding: EdgeInsets.only(left: 25),
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.pets),
                          title: Text(Lap.averageHeartRate(records: records)),
                          subtitle: Text("average heart rate"),
                        ),
                        ListTile(
                          leading: Icon(Icons.expand_more),
                          title: Text(Lap.minHeartRate(records: records)),
                          subtitle: Text("minimum heart rate"),
                        ),
                        ListTile(
                          leading: Icon(Icons.expand_less),
                          title: Text(Lap.maxHeartRate(records: records)),
                          subtitle: Text("maximum heart rate"),
                        ),
                        ListTile(
                          leading: Icon(Icons.unfold_more),
                          title: Text(Lap.sdevHeartRate(records: records)),
                          subtitle: Text("standard deviation heart rate"),
                        ),
                        ListTile(
                          leading: Icon(Icons.playlist_add),
                          title: Text(records.length.toString()),
                          subtitle: Text("number of measurements"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
      },
    );
  }
}
