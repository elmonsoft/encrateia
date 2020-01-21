import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';

class LapPowerWidget extends StatelessWidget {
  final Lap lap;

  LapPowerWidget({this.lap});

  @override
  Widget build(context) {
    return FutureBuilder<List<Event>>(
      future: Event.recordsByLap(lap: lap),
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.hasData) {
          var records = snapshot.data;
          return ListTileTheme(
            iconColor: Colors.lightGreen,
            child: ListView(
              padding: EdgeInsets.only(left: 25),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.playlist_add),
                  title: Text(records.length.toString()),
                  subtitle: Text("number of measurements"),
                ),
                ListTile(
                  leading: Icon(Icons.ev_station),
                  title: Text(Lap.averagePower(records: records) + " W"),
                  subtitle: Text("average power"),
                ),
                ListTile(
                  leading: Icon(Icons.expand_less),
                  title: Text(Lap.minPower(records: records) + " W"),
                  subtitle: Text("minimum power"),
                ),
                ListTile(
                  leading: Icon(Icons.expand_more),
                  title: Text(Lap.maxPower(records: records) + " W"),
                  subtitle: Text("maximum power"),
                ),
                ListTile(
                  leading: Icon(Icons.unfold_more),
                  title: Text(Lap.sdevPower(records: records) + " W"),
                  subtitle: Text("standard deviation power"),

                ),
              ],
            ),
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
