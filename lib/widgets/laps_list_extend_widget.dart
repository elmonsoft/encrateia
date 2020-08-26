import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/screens/show_lap_screen.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/models/weight.dart';

class LapsListExtendWidget extends StatefulWidget {
  const LapsListExtendWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;
  @override
  _LapsListExtendWidgetState createState() => _LapsListExtendWidgetState();
}

class _LapsListExtendWidgetState extends State<LapsListExtendWidget> {
  List<int> liLapIds = [];
  String powerFTP;
  String heartRateBase;
  String paceFTP;

  @override
  void initState() {
    getDataFTP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lap>>(
      future: widget.activity.laps,
      builder: (BuildContext context, AsyncSnapshot<List<Lap>> snapshot) {
        if (snapshot.hasData) {
          final List<Lap> laps = snapshot.data;
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
                  DataColumn(label: Text('Power zone'), numeric: true),
                  DataColumn(label: Text('Pace zone'), numeric: true),
                  DataColumn(label: Text('HR zone'), numeric: true),
                  // Metriken
                  DataColumn(
                      label: Text('Intensitätsfaktor\nWatt/FTP'),
                      numeric: true),
                  DataColumn(
                      label: Text('Effizienzindex\nSpeed/Power'),
                      numeric: true),
                  DataColumn(label: Text('EI@FT\n'), numeric: true),
                  DataColumn(
                      label: Text('Effizienzfaktor\nPower/HR'), numeric: true),
                  DataColumn(
                      label: Text('Effizienzfaktor\nSpeed/HR'), numeric: true),
                  DataColumn(label: Text('KJ/Km\nWatt/km'), numeric: true),
                  DataColumn(label: Text('ECOR\nWatt/v/kg/km'), numeric: true),
                  // minmax
                  DataColumn(label: Text('Power zone'), numeric: true),
                  DataColumn(label: Text('% Power'), numeric: true),
                  DataColumn(label: Text('Power avg\nWatt'), numeric: true),
                  DataColumn(label: Text('Power min\nWatt'), numeric: true),
                  DataColumn(label: Text('Power max\nWatt'), numeric: true),
                  DataColumn(label: Text('Pace zone'), numeric: true),
                  DataColumn(label: Text('% Pace'), numeric: true),
                  DataColumn(label: Text('Pace avg\nmin/km'), numeric: true),
                  DataColumn(label: Text('Pace min\nmin/km'), numeric: true),
                  DataColumn(label: Text('Pace max\nmin/km'), numeric: true),
                  DataColumn(label: Text('Speed avg\nKm/h'), numeric: true),
                  DataColumn(label: Text('Speed min\nKm/h'), numeric: true),
                  DataColumn(label: Text('Speed max\nKm/h'), numeric: true),
                  DataColumn(label: Text('HR zone'), numeric: true),
                  DataColumn(label: Text('% HRmax'), numeric: true),
                  DataColumn(label: Text('% HRcp'), numeric: true),
                  DataColumn(label: Text('HR avg\nbpm'), numeric: true),
                  DataColumn(label: Text('HR min\nbpm'), numeric: true),
                  DataColumn(label: Text('HR max\nbpm'), numeric: true),
                  DataColumn(label: Text('HR sdev\nbpm'), numeric: true),
                ],
                rows: laps.map((Lap lap) {
                  try {
                    lap.lm.weight = widget.activity.weight.toString();
                  } catch (e) {}
                  try {
                    lap.lm.FTPw = powerFTP;
                  } catch (e) {}
                  //try {lap.lm.HRcp = heartRateBase;} catch (e) {}
                  //try {lap.lm.FTPa = powerFTP;} catch (e) {}

                  lap.lm.strecke = (lap.totalDistance / 1000).toString();
                  lap.lm.dzeit = double.parse(lap.totalElapsedTime.toString());
                  lap.lm.dspeed = lap.avgSpeed;
                  try {
                    lap.lm.power = lap.avgPower.toStringAsFixed(3);
                  } catch (e) {}
                  lap.lm.HR = lap.avgHeartRate.toString();
                  getData(lap);
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
                      DataCell(Text(lap.index.toString())),
                      DataCell(Text(lap.lm.zeit)),
                      DataCell(
                          Text((lap.totalDistance / 1000)?.toStringAsFixed(2))),
                      DataCell(
                        Text((lap.totalAscent ?? 0 - (lap.totalDescent ?? 0))
                            .toStringAsFixed(2)),
                      ),
                      DataCell(Text(lap.avgPace.toStringAsFixed(2))),
                      DataCell(Text(avgHeartRateString(lap.avgHeartRate))),
                      DataCell(Text(lap.avgPower.toStringAsFixed(1))),
                      DataCell(Text(lap.lm.powerZoneName)),
                      DataCell(Text('- - -')),
                      DataCell(Text(lap.lm.heartRateZoneName)),
                      // Metriken
                      DataCell(Text(lap.lm.IF)),
                      DataCell(Text(lap.lm.EI)),
                      DataCell(Text(lap.lm.EIatFT)),
                      DataCell(Text(lap.lm.EFw)),
                      DataCell(Text(lap.lm.EFa)),
                      DataCell(Text(lap.lm.KJKM)),
                      DataCell(Text(lap.lm.ECOR)),
                      // min max
                      DataCell(Text(lap.lm.powerZoneName)),
                      DataCell(Text(lap.lm.power_pc)),
                      DataCell(Text(lap.avgPower.toStringAsFixed(1))),
                      DataCell(Text(lap.minPower.toStringAsFixed(1))),
                      DataCell(Text(lap.maxPower.toStringAsFixed(1))),
                      DataCell(Text('- - -')),
                      DataCell(Text(lap.lm.pace_pc)),
                      DataCell(Text(lap.lm.pace)),
                      DataCell(Text(lap.lm.speedPace(lap.minSpeed))),
                      DataCell(Text(lap.lm.speedPace(lap.maxSpeed))),
                      DataCell(Text((lap.avgSpeed * 3.6)?.toStringAsFixed(2))),
                      DataCell(
                          Text(((lap.minSpeed * 3.6))?.toStringAsFixed(2))),
                      DataCell(
                          Text(((lap.maxSpeed * 3.6))?.toStringAsFixed(2))),
                      DataCell(Text(lap.lm.heartRateZoneName)),
                      DataCell(Text(lap.lm.HRmax_pc)),
                      DataCell(Text(lap.lm.HRcp_pc)),
                      DataCell(Text(lap.avgHeartRate.toStringAsFixed(1))),
                      DataCell(Text(lap.minHeartRate.toStringAsFixed(1))),
                      DataCell(Text(lap.maxHeartRate.toStringAsFixed(1))),
                      DataCell(Text(lap.sdevHeartRate.toStringAsFixed(1))),

                      //
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('Loading'),
          );
        }
      },
    );
  }

  String avgHeartRateString(int avgHeartRate) {
    if (avgHeartRate != 255)
      return avgHeartRate.toString();
    else
      return '-';
  }

  Future<void> getDataFTP() async {
    // Weight
    final Weight weight = await Weight.getBy(
      athletesId: widget.athlete.id,
      date: widget.activity.timeCreated,
    );
    widget.activity.weight = weight.value ?? 0.0;

    // Power - FTP
    PowerZoneSchema powerZoneSchema = await PowerZoneSchema.getBy(
      athletesId: widget.athlete.id,
      date: widget.activity.timeCreated,
    );
    powerFTP = powerZoneSchema.base.toString() ?? '';

    // HR max/base
    final HeartRateZoneSchema heartRateZoneSchema =
        await HeartRateZoneSchema.getBy(
      athletesId: widget.athlete.id,
      date: widget.activity.timeCreated,
    );
    heartRateBase = heartRateZoneSchema.base.toString() ?? '';

    double dweight = widget.activity.weight;
    //print('Base: $dweight kg / $powerFTP Watt / $heartRateBase bpm ');

    // pace FTP
    paceFTP = '05:15';

    setState(() {});
  }

  Future<void> getData(Lap lap) async {
    int actId = widget.activity.id;
    int lapId = lap.id;

    //print('getData: $actId/$lapId');

    if (liLapIds.contains(lap.id)) {
      return;
    }

    lap.powerZone.then((value) {
      try {
        lap.lm.powerZoneName = value.name ?? '- - -';
      } catch (e) {
        lap.lm.powerZoneName = '- - -';
        print('catch Pzone');
      }
    });

    lap.heartRateZone.then((value) {
      try {
        lap.lm.heartRateZoneName = value.name ?? '- - -';
        setState(() {});
      } catch (e) {
        lap.lm.heartRateZoneName = '- - -';
        print('catch HRzone');
        setState(() {});
      }
    });

    liLapIds.add(lapId);
    //print('getData: $actId/$lapId ok');
  }
}
