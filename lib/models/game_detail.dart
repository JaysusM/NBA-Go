class GameDetail {
  String _gameId;
  List<int> _homeTeamLinescore, _awayTeamLinescore;
  List<GamePlayerStats> _homePlayers, _awayPlayers;
  int _homeTeamId, _awayTeamId;

  GameDetail.fromJSON(Map<String, dynamic> decodedJSON) {
    this._gameId = decodedJSON['basicGameData']['gameId'];
    this._homeTeamLinescore = decodedJSON['basicGameData']['hTeam']['linescore'];
    this._awayTeamLinescore = decodedJSON['basicGameData']['vTeam']['linescore'];
    this._homeTeamId = decodedJSON['basicGameData']['hTeam']['teamId'];
    this._awayTeamId = decodedJSON['basicGameData']['vTeam']['teamId'];
    this._homePlayers = new List<GamePlayerStats>();
    this._awayPlayers = new List<GamePlayerStats>();
    List<Map<String, dynamic>> activePlayers = decodedJSON['stats']['activePlayers'];
    for(Map<String, dynamic> player in activePlayers) {
      if (player['teamId'] == this._homeTeamId) {
        this._homePlayers.add(GamePlayerStats.fromJSON(player));
      } else {
        this._awayPlayers.add(GamePlayerStats.fromJSON(player));
      }
    }
  }

  String get gameId => _gameId;
  List<int> get homeTeamLinescore => _homeTeamLinescore;
  List<int> get awayTeamLinescore => _awayTeamLinescore;
}

class GamePlayerStats {
  String _personId, _jersey, _firstName, _lastName, _min, _fgm, _fga, _fgp,
  _ftm, _fta, _ftp, _tpm, _tpa, _tpp, _offReb, _defReb, _totReb, _ass, _pf, _stl, _to, _blk, _plusMinus;
  bool _isOnCourt;

  GamePlayerStats.fromJSON(Map<String, dynamic> decodedJSON) {
    this._personId = decodedJSON['personId'];
    this._jersey = decodedJSON['jersey'];
    this._firstName = decodedJSON['firstName'];
    this._lastName = decodedJSON['lastName'];
    this._min = decodedJSON['min'];
    this._fgm = decodedJSON['fgm'];
    this._fga = decodedJSON['fga'];
    this._fgp = decodedJSON['fgp'];
    this._ftm = decodedJSON['ftm'];
    this._fta = decodedJSON['fta'];
    this._ftp = decodedJSON['ftp'];
    this._tpm = decodedJSON['tpm'];
    this._tpa = decodedJSON['tpa'];
    this._tpp = decodedJSON['tpp'];
    this._offReb = decodedJSON['offReb'];
    this._defReb = decodedJSON['defReb'];
    this._totReb = decodedJSON['totReb'];
    this._ass = decodedJSON['assists'];
    this._pf = decodedJSON['pFouls'];
    this._stl = decodedJSON['steals'];
    this._to = decodedJSON['turnovers'];
    this._blk = decodedJSON['blocks'];
    this._plusMinus = decodedJSON['plusMinus'];
    this._isOnCourt = decodedJSON['isOnCourt'];
  }

  String get personId => _personId;
  String get jersey => _jersey;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get min => _min;
  String get fgm => _fgm;
  String get fga => _fga;
  String get fgp => _fgp;
  String get ftm => _ftm;
  String get fta => _fta;
  String get ftp => _ftp;
  String get tpm => _tpm;
  String get tpa => _tpa;
  String get tpp => _tpp;
  String get offReb => _offReb;
  String get defReb => _defReb;
  String get totReb => _totReb;
  String get ass => _ass;
  String get pf => _pf;
  String get stl => _stl;
  String get to => _to;
  String get blk => _blk;
  String get plusMinus => _plusMinus;
  bool get isOnCourt => _isOnCourt;
}