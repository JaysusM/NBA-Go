import 'package:http/http.dart';
import 'package:nba_go/repositories/nba_api_client.dart';

class NBALinks {
  
  static Future<NBALinks> nbaLinks = _createNBALinks();
  String _todayScoreboard, _gameScoreboard, _teams, _players;
  DateTime _currentDate;

  static Future<NBALinks> _createNBALinks() async {
    NBAApiClient nbaApiClient = new NBAApiClient(httpClient: new Client());
    Map<String, dynamic> linksJSON = await nbaApiClient.getNBALinksJSON();
    return NBALinks._private(linksJSON['links']);
  }

  NBALinks._private(Map<String, dynamic> linksJSON) {
    this._todayScoreboard = linksJSON['todayScoreboard'];
    this._gameScoreboard = linksJSON['scoreboard'];
    this._teams = linksJSON['teams'];
    this._players = linksJSON['leagueRosterPlayers'];
    this._currentDate = DateTime.parse(linksJSON['currentDate']);
  }

  String get todayScoreboard => _todayScoreboard;
  String get teams => _teams;
  String get players => _players;
  DateTime get currentDate => _currentDate;
  String scoreboard(String gameDate) => _gameScoreboard.replaceAll("{{gameDate}}", gameDate);
}