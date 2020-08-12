import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/activity.dart';

class ActivityOverviewWidget extends StatefulWidget {
  const ActivityOverviewWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityOverviewWidgetState createState() => _ActivityOverviewWidgetState();
}

class _ActivityOverviewWidgetState extends State<ActivityOverviewWidget> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List<Widget> get tiles {
    return <ListTile>[
      ListTile(
        title: Text(
            '${(widget.activity.distance / 1000).toStringAsFixed(2)} km'),
        subtitle: const Text('distance'),
      ),
      ListTile(
        title: Text(
            Duration(seconds: widget.activity.movingTime ?? 0).asString()),
        subtitle: const Text('moving time'),
      ),
      ListTile(
        title: Text(widget.activity.avgSpeed.toPace() +
            ' / ' +
            widget.activity.maxSpeed?.toPace()),
        subtitle: const Text('avg / max pace'),
      ),
      ListTile(
        title: Text((widget.activity.weight != null)
            ? (widget.activity.getAttribute(ActivityAttr.ecor) as double)
                    .toStringAsFixed(3) +
                ' kJ / kg / km'
            : 'not available'),
        subtitle: const Text('ecor'),
      ),
      ListTile(
        title: Text('${widget.activity.avgHeartRate} / '
            '${widget.activity.maxHeartRate} bpm'),
        subtitle: const Text('avg / max heart rate'),
      ),
      ListTile(
        title: Text('${widget.activity.avgPower.toStringAsFixed(1)} W'),
        subtitle: const Text('avg power'),
      ),
      ListTile(
        title: (widget.activity.avgPower != -1)
            ? Text(
                (widget.activity.avgPower / widget.activity.avgHeartRate)
                        .toStringAsFixed(2) +
                    ' W/bpm')
            : const Text('No power data available'),
        subtitle: const Text('power / heart rate'),
      ),
      ListTile(
        title: Text('${widget.activity.totalCalories} kcal'),
        subtitle: const Text('total calories'),
      ),
      ListTile(
        title: Text(DateFormat('dd MMM yyyy, h:mm:ss')
            .format(widget.activity.timeCreated)),
        subtitle: const Text('time created'),
      ),
      ListTile(
        title: Text('${widget.activity.totalAscent ?? 0} - '
                '${widget.activity.totalDescent ?? 0}'
                ' = ' +
            ((widget.activity.totalAscent ?? 0) -
                    (widget.activity.totalDescent ?? 0))
                .toString() +
            ' m'),
        subtitle: const Text('total ascent - descent = total climb'),
      ),
      ListTile(
        title:
            Text('${(widget.activity.avgRunningCadence ?? 0 * 2).round()} / '
                '${widget.activity.maxRunningCadence ?? 0 * 2} spm'),
        subtitle: const Text('avg / max steps per minute'),
      ),
      ListTile(
        title: Text(widget.activity.totalTrainingEffect.toString()),
        subtitle: const Text('total training effect'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      staggeredTiles:
          List<StaggeredTile>.filled(tiles.length, const StaggeredTile.fit(1)),
      mainAxisSpacing: 4,
      crossAxisCount:
          MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
      children: tiles,
    );
  }

  Future<void> getData() async {
    final Weight weight = await Weight.getBy(
      athletesId: widget.athlete.id,
      date: widget.activity.timeCreated,
    );
    setState(() {
      widget.activity.weight = weight?.value;
    });
  }
}
