class IntPlotPoint {
  IntPlotPoint({this.domain, this.measure});

  int domain;
  int measure;

  @override
  String toString() => '< IntPlotPoint | $domain | $measure >';
}

class DoublePlotPoint {
  DoublePlotPoint({this.domain, this.measure});

  int domain;
  double measure;

  @override
  String toString() => '< DoublePlotPoint | $domain | $measure >';
}

class EnergyPoint {
  EnergyPoint({this.energy, this.duration});

  int energy;
  int duration;

  @override
  String toString() => '< EnergyPlotPoint | $energy | $duration >';
}
