enum Conference {
  WEST,
  EAST
}

class TeamStanding {
  final int win, loss, gamesBehind, confRank;
  final double winPct;
  final String teamId;
  final Conference conference;

  TeamStanding.fromJSON(Map<String, dynamic> decodedJSON, this.conference) :
    this.win = int.parse(decodedJSON['win']),
    this.loss = int.parse(decodedJSON['loss']),
    this.winPct = double.parse(decodedJSON['winPct']),
    this.gamesBehind = int.parse(decodedJSON['gamesBehind']),
    this.confRank = int.parse(decodedJSON['confRank']),
    this.teamId = decodedJSON['teamId'];
}