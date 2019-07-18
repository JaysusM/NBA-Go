import 'package:equatable/equatable.dart';

enum GameStatus {
  NOTSTARTED,
  PLAYING,
  FINISHED
}

enum Period {
  FIRSTQUARTER,
  SECONDQUARTER,
  THIRDQUARTER,
  FOURTHQUARTER,
  FIRSTOVERTIME,
  SECONDOVERTIME,
  THIRDOVERTIME,
  FOURTHOVERTIME
}

class Game {
  //TODO: Add playoffs attribute and class

  final String gameId, clock;
  final DateTime startTimeUTC;
  final Period period;
  final GameStatus status;
  final GameTeam hTeam;
  final GameTeam vTeam;

  Game.fromJSON(Map<String, dynamic> data) : 
    this.gameId = data['gameId'],
    this.clock = data['clock'],
    this.startTimeUTC = DateTime.parse(data['startTimeUTC']),
    // We substract 1 because in API periods starts at 1 and in enums at 0
    this.period = Period.values[data['period']['current'] - 1],
    // Same as periods, we substract 1
    this.status = GameStatus.values[data['statusNum'] - 1],
    this.hTeam = GameTeam.fromJSON(data['hTeam']),
    this.vTeam = GameTeam.fromJSON(data['vTeam']);
}

class GameTeam {
  final String teamId, tricode;
  final int win, loss, seriesWin, seriesLoss, score;
  final List<int> lineScore;

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
  }