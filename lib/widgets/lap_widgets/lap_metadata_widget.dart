import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/lap.dart';

class LapMetadataWidget extends StatelessWidget {
  const LapMetadataWidget({this.lap});

  final Lap lap;
  
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      staggeredTiles: List<StaggeredTile>.filled(16, const StaggeredTile.fit(1)),
      mainAxisSpacing: 4,
      crossAxisCount:
          MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
      children: <Widget>[
        ListTile(
          title:
              Text(DateFormat('dd MMM yyyy, h:mm:ss').format(lap.db.timeStamp)),
          subtitle: const Text('timestamp'),
        ),
        ListTile(
          title: Text(lap.db.event),
          subtitle: const Text('event'),
        ),
        ListTile(
          title: Text(lap.db.sport + ' / ' + lap.db.subSport),
          subtitle: const Text('sport / sub sport'),
        ),
        ListTile(
          title: Text(lap.db.eventType + ' / ' + lap.db.eventGroup.toString()),
          subtitle: const Text('event type / group'),
        ),
        ListTile(
          title: Text(lap.db.avgVerticalOscillation.toStringAsFixed(2)),
          subtitle: const Text('avg vertical oscillation'),
        ),
        ListTile(
          title: Text(Duration(seconds: lap.db.totalElapsedTime).asString()),
          subtitle: const Text('total elapsed time'),
        ),
        ListTile(
          title: Text(Duration(seconds: lap.db.totalTimerTime).asString()),
          subtitle: const Text('total timer time'),
        ),
        ListTile(
          title: Text(
              '${lap.db.avgStanceTime} ms / ${lap.db.avgStanceTimePercent} %'),
          subtitle: const Text('avg stance time / avg stance time percent'),
        ),
        ListTile(
          title: Text(lap.db.lapTrigger),
          subtitle: const Text('lap trigger'),
        ),
        ListTile(
          title: Text('${lap.db.avgTemperature}° / ${lap.db.maxTemperature}°'),
          subtitle: const Text('avg / max temperature'),
        ),
        ListTile(
          title: Text(lap.db.avgFractionalCadence.toStringAsFixed(2) +
              ' / ' +
              lap.db.maxFractionalCadence.toStringAsFixed(2)),
          subtitle: const Text('avg / max fractional cadence'),
        ),
        ListTile(
          title: Text(lap.db.totalFractionalCycles.toStringAsFixed(2)),
          subtitle: const Text('total fractional cycles'),
        ),
        ListTile(
          title: Text(lap.db.startPositionLong.semicirclesAsDegrees() +
              ' E\n' +
              lap.db.startPositionLat.semicirclesAsDegrees() +
              ' N'),
          subtitle: const Text('start position'),
        ),
        ListTile(
          title: Text(lap.db.endPositionLong.semicirclesAsDegrees() +
              ' E\n' +
              lap.db.endPositionLat.semicirclesAsDegrees() +
              ' N'),
          subtitle: const Text('end position'),
        ),
        ListTile(
          title: Text(lap.db.intensity.toString()),
          subtitle: const Text('intensity'),
        ),
        ListTile(
          title: Text((lap.db.avgSpeed * 3.6).toStringAsFixed(2) +
              ' km/h / ' +
              (lap.db.maxSpeed * 3.6).toStringAsFixed(2) +
              ' km/h'),
          subtitle: const Text('avg / max speed'),
        ),
      ],
    );
  }
}
