class Player {

  String _firstName, _lastName, _personId, _teamId, _jersey, _pos;
  DateTime  _birthDateUTC;

  Player.fromJSON(Map<String, dynamic> decodedJSON) {
    this._firstName = decodedJSON['firstName'];
    this._lastName = decodedJSON['lastName'];
    this._personId = decodedJSON['personId'];
    this._teamId = decodedJSON['teamId'];
    this._jersey = decodedJSON['jersey'];
    this._pos = decodedJSON['pos'];
    try {
      if(decodedJSON['dateOfBirthUTC'].toString().isNotEmpty)
        this._birthDateUTC = DateTime.parse(decodedJSON['dateOfBirthUTC']);
    } catch(error) {
      print("Parsing error with date: ${decodedJSON['dateOfBirthUTC']}");
    }
  }

  String get firstName => this._firstName;
  String get lastName => this._lastName;
  String get personId => this._personId;
  String get teamId => this._teamId;
  String get jersey => this._jersey;
  String get pos => this._pos;
  String get fullName => '$_lastName, $_firstName';
  String get dobAge {
    if(this._birthDateUTC == null)
      return '';
    int ageInDays = (this._birthDateUTC.difference(DateTime.now().toUtc()).inDays).abs();
    return (ageInDays/365).truncate().toString();
  }
}