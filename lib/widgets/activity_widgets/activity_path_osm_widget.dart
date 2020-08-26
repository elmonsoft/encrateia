import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/my_path.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'dart:math';

class ActivityPathOsmWidget extends StatefulWidget {
  const ActivityPathOsmWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityPathOsmWidgetState createState() => _ActivityPathOsmWidgetState();
}

class _ActivityPathOsmWidgetState extends State<ActivityPathOsmWidget> {
  //RecordList<Event> records = RecordList<Event>(<Event>[]);
  List<Event> geoRecords = [];
  List<LatLng> path_points = [];
  LatLng centerPostition;
  LatLng startPosition;
  LatLng stopPosition;
  bool hasGPS = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    geoRecords = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (hasGPS) {
      LatLng neBoundary = LatLng(
          widget.activity.necLat.toWGS84(), widget.activity.necLong.toWGS84());
      LatLng swBoundary = LatLng(
          widget.activity.swcLat.toWGS84(), widget.activity.swcLong.toWGS84());
      centerPostition = LatLng(
          (widget.activity.necLat.toWGS84() +
                  widget.activity.swcLat.toWGS84()) /
              2,
          (widget.activity.necLong.toWGS84() +
                  widget.activity.swcLong.toWGS84()) /
              2);

      return Center(
        child: FlutterMap(
          options: MapOptions(
            //center: centerPostition,
            //zoom: 12.0,
            bounds: LatLngBounds(neBoundary, swBoundary),
            boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(25.0)),
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            MarkerLayerOptions(
              markers: [
                Marker(
                  point: startPosition,
                  builder: (ctx) => new Container(
                    child: Icon(
                      Icons.circle,
                      color: Colors.redAccent,
                      size: 16,
                    ),
                  ),
                ),
                Marker(
                  point: stopPosition,
                  builder: (ctx) => new Container(
                    child: Icon(
                      Icons.stop, // .crop_square_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
            PolylineLayerOptions(
              polylines: [
                Polyline(
                  points: path_points,
                  strokeWidth: 4.0,
                  color: Colors.purple,
                  isDotted: false,
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return const Center(
        child: Text('No coordinates available'),
      );
    }
  }

  Future<void> getData() async {
    try {
      //if (widget.activity.startPositionLat.toWGS84()<89.0 &&  widget.activity.startPositionLong.toWGS84()<179.0) hasGPS=true;
      hasGPS = widget.activity.startPositionLat.toWGS84() < 89.0 &&
              widget.activity.startPositionLong.toWGS84() < 179.0
          ? true
          : false;
      widget.activity.records.then((value) {
        geoRecords = value
            .where((Event value) =>
                value.positionLong != null &&
                value.positionLat != null &&
                value.positionLat.toWGS84() < 90.0 &&
                value.positionLat.toWGS84() > -90.0 &&
                value.positionLong.toWGS84() < 180.0 &&
                value.positionLong.toWGS84() > -180.0)
            .toList();

        path_points = geoRecords
            .map((val) =>
                LatLng(val.positionLat.toWGS84(), val.positionLong.toWGS84()))
            .toList();
/*
        startPosition = LatLng(
            widget.activity.startPositionLat.toWGS84(),
            widget.activity.startPositionLong.toWGS84());
        print('startPosition: $startPosition');

 */
        startPosition = path_points[0];
        stopPosition = path_points[path_points.length - 1];

        setState(() {});
      });
    } catch (e) {
      print(e.toString());
    }

    /*
    print('MinMax:');
    printMinMax(records.map((e) => e.altitude).toList(), 'Alt');
    printMinMax(records.map((e) => e.positionLat.toWGS84()).toList(), 'Lat');
    printMinMax(records.map((e) => e.positionLong.toWGS84()).toList(), 'Long');
    */

    setState(() {});
  }

  void printMinMax(List<double> list, String type) {
    double amax = list.reduce(max).truncateToDouble();
    double amin = list.reduce(min).truncateToDouble();
    print('$type -> min: $amin / max: $amax');
  }
}

extension postitionFormatter on double {
  double toWGS84() {
    return this * (180 / pow(2, 31));
  }
}
