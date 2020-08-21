import 'models.dart';
import 'package:meta/meta.dart';

class PlayerDetail {
  SeasonStats _currentSeasonStats;
  Player _player;
  List<SeasonStats> _allSeasonStats;

  PlayerDetail.fromJSON(Map<String, dynamic> decodedJSON, this._player)
    : assert(_player != null) {
    _allSeasonStats = new List<SeasonStats>();
    Map<String, dynamic> currentSeasonStatsJSON = decodedJSON['league']['standard']['stats']['latest'];
    this._currentSeasonStats = SeasonStats.fromJSON(currentSeasonStatsJSON, teamId: decodedJSON['league']['standard']['teamId']);

    List<dynamic> allSeasons = decodedJSON['league']['standard']['stats']['regularSeason']['season'];
    for(dynamic season in allSeasons) {
      season['teams'].forEach((dynamic teamSeason) => this._allSeasonStats.add(SeasonStats.fromJSON(teamSeason, seasonYear: season['seasonYear'])));
    }
  }

  Player get player => this._player;
  SeasonStats get currentSeasonStats => this._currentSeasonStats;
  List<SeasonStats> get allSeasonStats => this._allSeasonStats;
}

class SeasonStats {
  int _seasonYear;
  String _teamId;
  double _ppg, _rpg, _apg, _mpg, _topg, _spg, _bpg,
    _tpp, _ftp, _fgp, _plusMinus, _min;

  SeasonStats.fromJSON(Map<String, dynamic> decodedJSON, {int seasonYear, String teamId}) {
    this._seasonYear = (seasonYear != null) ? seasonYear : decodedJSON['seasonYear'];
    this._teamId = (teamId != null) ? teamId : decodedJSON['teamId'];
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
  String get teamId => this._teamId;
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