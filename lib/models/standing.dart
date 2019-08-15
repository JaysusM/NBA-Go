enum Conference {
  WEST,
  EAST
}

class TeamStanding {
  int _win, _loss, _gamesBehind, _confRank;
  double _winPct;
  String _teamId;
  Conference _conference;

  TeamStanding.fromJSON(Map<String, dynamic> decodedJSON, this._conference, int index) {
    this._teamId = decodedJSON['teamId'];
    this._win = int.parse(decodedJSON['win']);
    this._loss = int.parse(decodedJSON['loss']);
    this._gamesBehind = int.parse(decodedJSON['gamesBehind']);

    try {
      this._confRank = int.parse(decodedJSON['confRank']);
    } catch(_) {
      this._confRank = index;
    }

    try {
      this._winPct = double.parse(decodedJSON['winPct']);
    } catch (_) {
      this._winPct = 0.0;
    }
  }

  int get win => _win;
  int get loss => _loss;
  double get winPct => _winPct;
  int get gamesBehind => _gamesBehind;
  int get confRank => _confRank;
  String get teamId => _teamId;
  Conference get conference => _conference;
}