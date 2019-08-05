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
    this._ppg = double.parse(decodedJSON['ppg']);
    this._apg = double.parse(decodedJSON['apg']);
    this._rpg = double.parse(decodedJSON['rpg']);
    this._mpg = double.parse(decodedJSON['mpg']);
    this._topg = double.parse(decodedJSON['topg']);
    this._spg = double.parse(decodedJSON['spg']);
    this._bpg = double.parse(decodedJSON['bpg']);
    this._tpp = double.parse(decodedJSON['tpp']);
    this._ftp = double.parse(decodedJSON['ftp']);
    this._fgp = double.parse(decodedJSON['fgp']);
    this._plusMinus = double.parse(decodedJSON['plusMinus']);
    this._min = double.parse(decodedJSON['min']);
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
}