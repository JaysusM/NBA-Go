import 'models.dart';
import 'package:meta/meta.dart';

class PlayerDetail {
  _SeasonStats _currentSeasonStats;
  Player _player;

  PlayerDetail.fromJSON(Map<String, dynamic> decodedJSON, this._player)
    : assert(_player != null) {
    Map<String, dynamic> currentSeasonStatsJSON = decodedJSON['league']['standard']['stats']['latest'];
    this._currentSeasonStats = _SeasonStats.fromJSON(currentSeasonStatsJSON);
  }

  Player get player => this._player;
  _SeasonStats get currentSeasonStats => this._currentSeasonStats;
}

class _SeasonStats {
  int _seasonYear;
  double _ppg, _rpg, _apg, _mpg, _topg, _spg, _bpg,
    _tpp, _ftp, _fgp, _plusMinus, _min;

  _SeasonStats.fromJSON(Map<String, dynamic> decodedJSON) {
    this._seasonYear = decodedJSON['seasonYear'];
    this._ppg = _parseStat(statName: 'ppg', statMap: decodedJSON);
    this._apg = _parseStat(statName: 'apg', statMap: decodedJSON);
    this._rpg = _parseStat(statName: 'rpg', statMap: decodedJSON);
    this._mpg = _parseStat(statName: 'mpg', statMap: decodedJSON);
    this._topg = _parseStat(statName: 'topg', statMap: decodedJSON);
    this._spg = _parseStat(statName: 'spg', statMap: decodedJSON);
    this._bpg = _parseStat(statName: 'bpg', statMap: decodedJSON);
    this._tpp = _parseStat(statName: 'tpp', statMap: decodedJSON);
    this._ftp = _parseStat(statName: 'ftp', statMap: decodedJSON);
    this._fgp = _parseStat(statName: 'fgp', statMap: decodedJSON);
    this._plusMinus = _parseStat(statName: 'plusMinus', statMap: decodedJSON);
    this._min = _parseStat(statName: 'min', statMap: decodedJSON);
  }

  int get seasonYear => this._seasonYear;
  double get ppg => this._ppg;
  double get rpg => this._rpg;
  double get apg => this._apg;
  double get mpg => this._mpg;
  double get topg => this._topg;
  double get spg => this._spg;
  double get bpg => this._bpg;
  double get tpp => this._tpp;
  double get ftp => this._ftp;
  double get fgp => this._fgp;
  double get plusMinus => this._plusMinus;
  double get min => this._min;

  double _parseStat({@required String statName, @required Map<String, dynamic> statMap}) {
    String statValue = statMap[statName];
    List<String> noValues = ['0', '-1', ''];
    return (noValues.contains(statValue)) ? 0.0 : double.parse(statValue);
  }
}