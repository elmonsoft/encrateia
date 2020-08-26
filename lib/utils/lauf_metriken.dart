//import 'package:encrateia/models/weight.dart';
//import 'package:flutter/material.dart';

import 'lauftool.dart';

class Metriken extends Laufzeit {
  // Konstanten
  double _dweight;
  double _dFTPw;
  double _dFTPa;
  double _dHRmax;
  double _dHRcp;
  //
  double _dpower;
  int _dpower_pc;
  double _dHR;
  int _dHRmax_pc;
  int _dHRcp_pc;
  int _pace_pc;
  // Zone
  String _powerZoneName;
  String _heartRateZoneName;
  String _paceZoneName;

  Metriken() : super() {
    _dweight = 74.5;
    _dFTPw = 261.0;
    _dHRmax = 202;
    _dHRcp = 180;
    FTPa = '05:15';
  }

  @override
  void show() {
    double kmh = 0.0;

    if (dspeed != null)
        kmh = dspeed * 3.6;

    print(
        'Strecke: $strecke / Zeit: $zeit / Pace: $pace / Kmh: $kmh / Speed: $dspeed');
  }

  // FTPw
  String get FTPw {
    if (_dFTPw == null) return '';
    return _dFTPw.round().toString();
  }

  set FTPw(String FTPw) {
    try {
      _dFTPw = double.parse(FTPw);
    } catch (e) {
      //print(e.toString());
      _dFTPw = null;
      throw e;
    }
  }

  // FTPa
  String get FTPa => pace2str(_dFTPa);

  set FTPa(String FTPa) {
    try {
      _dFTPa = checkPace(FTPa);
    } catch (e) {
      //print(e.toString());
      _dFTPa = null;
      throw e;
    }
  }

  // Power
  String get power => doubleIntStr(_dpower);

  set power(String power) {
    try {
      _dpower = double.parse(power);
    } catch (e) {
      //print(e.toString());
      _dpower = null;
      throw e;
    }
  }

  // HR
  String get HR => doubleIntStr(_dHR);

  set HR(String HR) {
    try {
      if (HR == '255') {
        _dHR = null;
        return;
      }
      _dHR = double.parse(HR);
    } catch (e) {
      //print(e.toString());
      _dHR = null;
      throw e;
    }
  }

  // Gewicht
  String get weight => _dweight.toString();
  set weight(String weight) {
    try {
      _dweight = double.parse(weight);
    } catch (e) {
      //print(e.toString());
      //print('weight: $weight');
      _dweight = null;
      throw e;
    }
  }

  // HR max
  String get HRmax => _dHRmax.toString();
  set HRmax(String HRmax) {
    try {
      _dHRmax = double.parse(HRmax);
    } catch (e) {
      //print(e.toString());
      _dHRmax = null;
      throw e;
    }
  }

  // HR cp
  String get HRcp => _dHRcp.toString();
  set HRcp(String HRmax) {
    try {
      _dHRcp = double.parse(HRcp);
    } catch (e) {
      //print(e.toString());
      _dHRcp = null;
      throw e;
    }
  }

  // percent
  String get HRmax_pc {
    if (_dHR == null || _dHRmax == null) return '- - -';
    return (_dHR * 100 / _dHRmax).round().toString();
  }

  String get HRcp_pc {
    if (_dHR == null || _dHRcp == null) return '- - -';
    return (_dHR * 100 / _dHRcp).round().toString();
  }

  String get power_pc {
    if (_dpower == null || _dFTPw == null) return '- - -';
    return (_dpower * 100 / _dFTPw).round().toString();
  }

  String get pace_pc {
    if (dpace == null || _dFTPa == null) return '- - -';
    if(dspeed == 0.0) return '0';
    return (_dFTPa * 100 / dpace).round().toString();
  }

  // Power/HR/Pace Zone
  set powerZoneName(String zone) => _powerZoneName = zone;
  String get powerZoneName => _powerZoneName ?? '- - -';
  set heartRateZoneName(String zone) => _heartRateZoneName = zone;
  String get heartRateZoneName => _heartRateZoneName ?? '- - -';
  set paceZoneName(String zone) => _paceZoneName = zone;
  String get paceZoneName => _paceZoneName ?? '- - -';

  void zeigeMetriken() {
    print('Zeige Metriken:');
    /*
    print('Max:');
    print('HRmax: $_dHRmax%');
    print('HRcp: $_dHRcp%');
    print('FTPw: $FTPw%');
    print('FTPa: $FTPa%');
    print('weight: $weight%');
    print('%:');
    print('HRmax_pc: $HRmax_pc%');
    print('HRcp_pc: $HRcp_pc%');
    print('power_pc: $power_pc%');
    print('pace_pc: $pace_pc%');
     */
    print('power: $power / $power_pc% / $FTPw');
    print('pace: $pace / $pace_pc% / $FTPa');
    print('HR: $HR / max $HRmax_pc% / cp $HRcp_pc% / $HRmax / $HRcp');
    String IF = calcIF();
    String EI = calcEI();
    String EIaFT = calcEIatFT();
    String EFw = calcEFw();
    String EFa = calcEFa();
    String ECOR = calcECOR();
    print(
        'IF: $IF / EI: $EI / EI@FT: $EIaFT / EFw: $EFw / EFa: $EFa / ECOR: $ECOR');
  }

  String get IF => calcIF();
  // IF - Intensitätsfaktor = NP / rFTPw
  String calcIF() {
    try {
      return roundDigits(_dpower / _dFTPw, digit: 3);
    } catch (e) {
      return '- - -';
    }
  }

  String get EI => calcEI();
  // EI - Effizienzindex = Geschwindigkeit / Leisung // [m/min Watt = m/(min * Watt)]
  String calcEI() {
    try {
      return roundDigits(60 * dspeed / _dpower, digit: 3);
    } catch (e) {
      return '- - -';
    }
  }

  String get EIatFT => calcEIatFT();
  // EI@FT  = rFTPa / rFTPw [m/min / Watt]
  String calcEIatFT() {
    try {
      double speed = 3600 / (_dFTPa * 3.6);
      return roundDigits(60 * speed / _dFTPw, digit: 3);
    } catch (e) {
      return '- - -';
    }
  }

  String get EFw => calcEFw();
  // EF watt - Effizienzfaktor = NP / HR [Watt / bpm]
  String calcEFw() {
    try {
      return roundDigits(_dpower / _dHR, digit: 3);
    } catch (e) {
      return '- - -';
    }
  }

  String get EFa => calcEFa();
  // EF pace - Effizienzfaktor = NGS / HR [m/min / bpm = m/(min * bpm)]
  String calcEFa() {
    try {
      return roundDigits(60 * dspeed / _dHR, digit: 3);
    } catch (e) {
      return '- - -';
    }
  }

  String get KJKM => calcKJ_KM();
  //KJ/Km - Energiebedarf / Strecke
  String calcKJ_KM() {
    try {
      return roundDigits(_dpower / (dstrecke), digit: 3);
    } catch (e) {
      return '- - -';
    }
  }

  String get ECOR => calcECOR();
  // ECOR = P (W/kg) / v (m/s) in kJ / kg Körpergewicht / km
  // ECOR = P / (kg * v * km )
  String calcECOR() {
    try {
      //print('lm: weiht: $weight $_dpower $dspeed');
      return roundDigits(1000 * _dpower / (dspeed * _dweight * dstrecke),
          digit: 3);
    } catch (e) {
      return '- - -';
    }
  }

/*
  3/9 Test
  rFTPa / rFTPw = (3min + 9min)/2 *9/10
  FTP / CP = (9x 9min + 3x 3min)(9+3)
  van Dijk (Das Geheimnis des Laufens)
  FTP 93% -> 20 min Laufen
  FTP 88% -> 10 min Laufen
   */
  void calc_3_9_test(double w3, double w9) {
    double rFTP90 = (w3 + w9) / 2;
    double rFTP = (rFTP90 * 0.9).roundToDouble();
    double CP = (9 * w9 + 3 * w3) / (9 + 3);
    double dijk = w9 * 88 / 100;
    print('dijk $dijk / rFTP $rFTP / CP $CP');
  }
}
