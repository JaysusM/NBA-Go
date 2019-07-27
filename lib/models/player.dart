class Player {

  String _firstName, _lastName, _personId, _teamId, _jersey, _pos;

  Player.fromJSON(Map<String, dynamic> decodedJSON) {
    this._firstName = decodedJSON['firstName'];
    this._lastName = decodedJSON['lastName'];
    this._personId = decodedJSON['personId'];
    this._teamId = decodedJSON['teamId'];
    this._jersey = decodedJSON['jersey'];
    this._pos = decodedJSON['pos'];
  }

  String get firstName => this._firstName;
  String get lastName => this._lastName;
  String get personId => this._personId;
  String get teamId => this._teamId;
  String get jersey => this._jersey;
  String get pos => this._pos;
  String get fullName => '$_lastName, $_firstName';
}