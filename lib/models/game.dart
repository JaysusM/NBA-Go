enum GameStatus {
  NOTSTARTED,
  PLAYING,
  FINISHED
}

enum Period {
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

  final String gameId, clock;
  final DateTime startTime;
  final Period period;
  final GameStatus status;
  final GameTeam hTeam;
  final GameTeam vTeam;

  Game.fromJSON(Map<String, dynamic> data) : 
    this.gameId = data['gameId'],
    this.clock = data['clock'],
    this.startTime = DateTime.parse(data['startTimeUTC']).toLocal(),
    // We substract 1 because in API periods starts at 1 and in enums at 0
    this.period = Period.values[data['period']['current'] - 1],
    // Same as periods, we substract 1
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
  final String teamId, tricode;
  final int win, loss, seriesWin, seriesLoss, score;
  final List<int> lineScore;
  bool _isWinner;

  GameTeam.fromJSON(Map<String, dynamic> data):
    this.teamId = data['teamId'],
    this.tricode = data['triCode'],
    this.win = int.parse(data['win']),
    this.loss = int.parse(data['loss']),
    this.seriesLoss = int.parse(data['seriesLoss']),
    this.seriesWin = int.parse(data['seriesWin']),
    this.score = int.parse(data['score']),
    this.lineScore = new List<int>()
    {
      data['linescore'].forEach((scoreEntry) => this.lineScore.add(int.parse(scoreEntry['score'])));        
    }

  set isWinner(bool value) {
    this._isWinner = value;
  }

  bool get isWinner => this._isWinner;
}