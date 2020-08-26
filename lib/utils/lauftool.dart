import 'dart:math';

class Laufzeit{
  double _dstrecke;  // [m]
  double _dzeit;   // [s]
  double _dpace;  // [s/km]
  double _dspeed;  // [m/s]
  double _drieger;
  double _drieger_k=1.06;

  Laufzeit();

  void show() {
    print('Strecke: $strecke / Zeit: $zeit / Pace: $pace / Speed: $_dspeed');
  }


  double get dstrecke => _dstrecke;

  String get  strecke {
    if (_dstrecke == null) return '';
    final double hstrecke = _dstrecke.round() / 1000;
    final int istrecke = hstrecke.toInt();
    if (hstrecke == istrecke){
      return hstrecke.toInt().toString();
    } else {
      return hstrecke.toString();
    }
    return '';
  }

  set strecke (String strecke) {
    if (strecke.isEmpty) {
      _dstrecke=null;
      return;
    }
    try {
      _dstrecke = 1000 * double.parse(strecke);
    }catch(e){
      _dstrecke = null;
      throw e;
    }
  }

  set zeit(String zeit) {
    try {
      _dzeit = checkZeit(zeit);
    }catch(e){
      //print(e.toString());
      _dzeit = null;
      throw e;
    }
  }

  set dzeit (double dzeit){
    try {
      _dzeit = dzeit;
    }catch(e){
      //print(e.toString());
      _dzeit = null;
      throw e;
    }
  }

  double get dzeit => _dzeit;

  String get zeit {
    if (_dzeit == null) return '';
    final int ihh =_dzeit ~/ 3600;
    final int imm = (_dzeit / 3600*60).toInt()%60;
    final int iss = _dzeit.remainder(60).toInt();
    //print('$_dzeit $ihh $imm $iss');
    final String shh = ihh.toString().padLeft(2, '0');
    final String smm = imm.toString().padLeft(2, '0');
    final String sss = iss.toString().padLeft(2, '0');
    return shh + ':' + smm+':'+sss;
  }

  set pace (String pace){
    try {
      _dpace = checkPace(pace);
      _dspeed = 1000/_dpace;
    }catch(e){
      //print('error pace: ${e.toString()}');
      _dpace = null;
      _dspeed = null;
      throw e;
    }
  }

  String get pace {
    if (_dpace == null) return '';
    final int imm = _dpace ~/ 60;
    final int iss = _dpace.remainder(60).toInt();
    final String smm = imm.toString().padLeft(2, '0');
    final String sss = iss.toString().padLeft(2, '0');
    return smm+':'+sss;
  }

  double get dpace => _dpace;
  double get dspeed => _dspeed;

  set dspeed (double dspeed){
    if (dspeed == 0.0){
      _dpace = 0.0;
      _dspeed = 0.0;
      return;
    }
    try {
      _dspeed = dspeed;
      _dpace = 1000/_dspeed;
    }catch(e){
      //print('error dspeed: ${e.toString()}');
      _dpace = null;
      _dspeed = null;
      //throw e;
    }
  }

  String speedPace(double speed){
    if (speed == null || speed == 0.0) return '';
    double pace = 1000/speed;

    final int imm = pace ~/ 60;
    final int iss = pace.remainder(60).toInt();
    final String smm = imm.toString().padLeft(2, '0');
    final String sss = iss.toString().padLeft(2, '0');
    //print('spedde -> $smm:$sss $speed / $pace');
    return smm+':'+sss;
  }

  String get rieger_k {
    if (_drieger_k == null) return '';
    return _drieger_k.toString();
  }

  set rieger_k (String rieger_k){
    try {
      _drieger_k = double.parse(rieger_k);
    }catch(e){
      //print(e.toString());
      _drieger_k = null;
      throw e;
    }
  }

  String get rieger {
    if (_drieger == null) return '';
    final int ihh =_drieger ~/ 3600;
    final int imm = (_drieger / 3600*60).toInt()%60;
    final int iss = _drieger.remainder(60).toInt();
    //print('_drieger $ihh $imm $iss');
    final String shh = ihh.toString().padLeft(2, '0');
    final String smm = imm.toString().padLeft(2, '0');
    final String sss = iss.toString().padLeft(2, '0');
    return shh + ':' + smm+':'+sss;
  }

  double checkZeit(String zeit){
    if (zeit.length < 8) return null;
    final String hh = zeit.substring(0, 2);
    final String mm = zeit.substring(3, 5);
    final String ss = zeit.substring(6, 8);
    final int sec = int.parse(ss);
    final int min = int.parse(mm);
    if (sec > 59) throw 'Zeit in HH:MM:SS';
    if (min > 59) throw 'Zeit in HH:MM:SS';
    try {
      final double zh = double.parse(hh);
      final double zm = double.parse(mm);
      final double zs = double.parse(ss);
      return zh*3600 + zm*60 + zs;;
    } catch (e) {
      _dzeit = null;
      throw e.toString();
    }
  }

  double checkPace(String pace){
    if (pace.length < 5) return null;
    final String left = pace.substring(0, 2);
    final String right = pace.substring(3, 5);
    final int sec = int.parse(right);
    if (sec > 59) throw 'Pace in mm:ss';
    try {
      final double zl = double.parse(left);
      final double zr = double.parse(right);
      return zl * 60 + zr;
    } catch (e) {
      _dpace = null;
      throw e.toString();
    }
  }

  String calcStrecke(){
    if (_dpace == null) return '';
    if (_dzeit == null) return '';
    _dstrecke = _dzeit *1000 / _dpace;
    return strecke;
  }

  String calcPace(){
    if (_dstrecke == null) return '';
    if (_dzeit == null) return '';
    _dpace = _dzeit *1000 / _dstrecke;
    _dspeed = 3600/(_dpace*3.6);
    return pace;
  }

  String calcZeit(){
    if (_dstrecke == null) return '';
    if (_dpace == null) return '';
    _dzeit =  _dpace * _dstrecke / 1000;
    return zeit;
  }

  /*
  Rieger-Formel
  Ermüdungsfaktor k=1,06
  T2 = T1 * (D2:D1)^k
  https://de.wikipedia.org/wiki/Peter_Riegel
   */
  String calcRiegerFormel(String strecke2){
    double _dstrecke2;
    if (strecke2.isEmpty) {
      return '';
    }
    if (_drieger_k == null) return '';
    try {
      _dstrecke2 = 1000 * double.parse(strecke2);
    }catch(e){
      return '';
    }
    if (_dstrecke2 < 1000) return '';
    //if (_dstrecke2 > 45000) return '';
    //print('berechne Rieger');
    _drieger = _dzeit * pow(_dstrecke2/_dstrecke, _drieger_k);
  return rieger;
  }

  String pace2str(double pace){
    if (pace == null) return '';
    final int imm = pace ~/ 60;
    final int iss = pace.remainder(60).toInt();
    final String smm = imm.toString().padLeft(2, '0');
    final String sss = iss.toString().padLeft(2, '0');
    return smm + ':' + sss;
  }

  String doubleIntStr(double value){
    if (value == null) return '';
    return value.round().toString();
  }

  String roundDigits(double value, {int digit=2}){
    try {
      final double h = pow(10, digit).toDouble();
      /*
      print('value: $value, digit: $digit h: $h');
      print(h*value);
      print((h*value).roundToDouble());
      print((h*value).roundToDouble()/h);
      print(((h*value).roundToDouble()/h).toString());



       */
      return ((h*value).roundToDouble()/h).toString();
    } catch (e) {
      return '';
    }
  }

}