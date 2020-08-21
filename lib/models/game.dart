enum GameStatus {
  NOT_STARTED,
  PLAYING,
  FINISHED
}

enum Period {
  NOT_STARTED,
  QT1,
  QT2,
  QT3,
  QT4,
  OT1,
  OT2,
  OT3,
  OT4
}

class Game {
  //TODO: Add playoffs attribute and class

  final String gameId, clock, gameDate;
  final DateTime startTime;
  final Period period;
  final GameStatus status;
  final GameTeam hTeam;
  final GameTeam vTeam;

  Game.fromJSON(this.gameDate, Map<String, dynamic> data) : 
    this.gameId = data['gameId'],
    this.clock = (data['clock'].toString().isEmpty) ? 'END' : data['clock'],
    this.startTime = DateTime.parse(data['startTimeUTC']).toLocal(),    
    this.period = Period.values[data['period']['current']],
    // We subtract 1 because in API status starts at 1, but enums starts at 0
    this.status = GameStatus.values[data['statusNum'] - 1],
    this.hTeam = GameTeam.fromJSON(data['hTeam']),
    this.vTeam = GameTeam.fromJSON(data['vTeam']) {
      if(this.status == GameStatus.FINISHED) {        
        this.hTeam.isWinner = (this.hTeam.score > this.vTeam.score);
        this.vTeam.isWinner = (this.vTeam.score > this.hTeam.score);
      }
    }
}

class GameTeam {
  String _teamId, _tricode;
  int _win, _loss, _seriesWin, _seriesLoss, _score;
  List<int> _lineScore;
  bool _isWinner;

  GameTeam.fromJSON(Map<String, dynamic> data):
    this._teamId = data['teamId'],
    this._tricode = data['triCode'],
    this._lineScore = new List<int>()
    {
      data['linescore'].forEach((scoreEntry) => this._lineScore.add(int.parse(scoreEntry['score'])));        
      this._win = parseValueFromStringCheckingNull(data['win']);
      this._loss = parseValueFromStringCheckingNull(data['loss']);
      this._seriesLoss = parseValueFromStringCheckingNull(data['seriesLoss']);
      this._seriesWin = parseValueFromStringCheckingNull(data['seriesWin']);
      this._score = parseValueFromStringCheckingNull(data['score']);
      this._isWinner = false;
    }

  int parseValueFromStringCheckingNull(String value) {
    return (value.isNotEmpty) ? int.parse(value) : 0;
  }

  set isWinner(bool value) {
    this._isWinner = value;
  }

  bool get isWinner => this._isWinner;
  int get win => this._win;
  int get loss => this._loss;
  int get seriesWin => this._seriesWin;
  int get seriesLoss => this._seriesLoss;
  int get score => this._score;
  List<int> get lineScore => this._lineScore;
  String get tricode => this._tricode;
  String get teamId => this._teamId;
}