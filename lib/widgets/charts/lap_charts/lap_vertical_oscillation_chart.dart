import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/graph_utils.dart';

class LapVerticalOscillationChart extends StatelessWidget {
  const LapVerticalOscillationChart({
    @required this.records,
    @required this.minimum,
    @required this.maximum,
  });

  final RecordList<Event> records;
  final double minimum;
  final double maximum;

  @override
  Widget build(BuildContext context) {
    final int offset = records.first.distance.round();

    final List<Series<Event, int>> data = <Series<Event, int>>[
      Series<Event, int>(
        id: 'Vertical Oscillation',
        colorFn: (_, __) => Color.black,
        domainFn: (Event record, _) => record.distance.round() - offset,
        measureFn: (Event record, _) => record.verticalOscillation,
        data: records,
      )
    ];

    return AspectRatio(
      aspectRatio:
          MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2,
      child: LineChart(
        data,
        defaultRenderer: LineRendererConfig<num>(
          includeArea: true,
          strokeWidthPx: 1,
        ),
        primaryMeasureAxis: NumericAxisSpec(
          tickProviderSpec: const BasicNumericTickProviderSpec(
            zeroBound: false,
            dataIsInWholeNumbers: false,
            desiredTickCount: 5,
          ),
          viewport: NumericExtents(minimum, maximum),
        ),
        behaviors: GraphUtils.axis(
          measureTitle: 'Vertical Oscillation (cm)',
        ),
      ),
    );
  }
}
