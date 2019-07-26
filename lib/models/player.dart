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

  get firstName => this._firstName;
  get lastName => this._lastName;
  get personId => this._personId;
  get teamId => this._teamId;
  get jersey => this._jersey;
  get pos => this._pos;

}