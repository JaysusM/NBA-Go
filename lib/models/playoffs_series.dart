class PlayoffsSeries {

  String _roundNum, _confName, _seriesId;
  PlayoffTeamRow _topTeam, _bottomTeam;
  bool _isSeriesCompleted, _isGameLive;

  PlayoffsSeries.fromJSON(Map<String, dynamic> decodedJSON) {
    _roundNum = decodedJSON['roundNum'];
    _confName = decodedJSON['confName'];
    _seriesId = decodedJSON['seriesId'];
    _topTeam = PlayoffTeamRow.fromJSON(decodedJSON['topRow']);
    _bottomTeam = PlayoffTeamRow.fromJSON(decodedJSON['bottomRow']);
    _isSeriesCompleted = decodedJSON['isSeriesCompleted'];
    _isGameLive = decodedJSON['isGameLive'];
  }

  get bottomTeam => _bottomTeam;
  PlayoffTeamRow get topTeam => _topTeam;
  get seriesId => _seriesId;
  get confName => _confName;
  String get roundNum => _roundNum;
  bool get isSeriesCompleted => _isSeriesCompleted;
  bool get isGameLive => _isGameLive;
}

class PlayoffTeamRow {
  String _teamId, _seedNum, _wins;
  bool _isSeriesWinner;

  PlayoffTeamRow.fromJSON(Map<String, dynamic> decodedJSON) {
      _teamId = decodedJSON['teamId'];
      _seedNum = decodedJSON['seedNum'];
      _wins = decodedJSON['wins'];
      _isSeriesWinner = decodedJSON['isSeriesWinner'];
  }

  bool get isSeriesWinner => _isSeriesWinner;
  get wins => _wins;
  get seedNum => _seedNum;
  String get teamId => _teamId;
}