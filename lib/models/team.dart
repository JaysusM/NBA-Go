class Team {
  final bool isNBAFranchise, isAllStar;
  final String city, fullName, tricode, teamId, confName;

  Team.fromJSON(Map<String, dynamic> decodedJSON) :
    this.isNBAFranchise = decodedJSON['isNBAFranchise'],
    this.isAllStar = decodedJSON['isAllStar'],
    this.city = decodedJSON['city'],
    this.fullName = decodedJSON['fullName'],
    this.tricode = decodedJSON['tricode'],
    this.teamId = decodedJSON['teamId'],
    this.confName = decodedJSON['confName'];

  String get shortName => this.fullName.split(' ').last;
}