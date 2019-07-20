import 'package:http/http.dart';
import 'package:nba_go/repositories/nba_api_client.dart';

class NBALinks {
  
  static Future<NBALinks> nbaLinks = createNBALinks();
  String _todayScoreboard, _gameScoreboard, _teams, _players;

  static Future<NBALinks> createNBALinks() async {
    NBAApiClient nbaApiClient = new NBAApiClient(httpClient: new Client());
    Map<String, dynamic> linksJSON = await nbaApiClient.getNBALinksJSON();
    return NBALinks._private(linksJSON['links']);
  }

  NBALinks._private(Map<String, dynamic> linksJSON) {
    this._todayScoreboard = linksJSON['todayScoreboard'];
    this._gameScoreboard = linksJSON['scoreboard'];
    this._teams = linksJSON['teams'];
    this._players = linksJSON['leagueRosterPlayers'];
  }

  get todayScoreboard => _todayScoreboard;
  get teams => _teams;
  get players => _players;
  gameScoreboard(String gameId) => _gameScoreboard.replaceAll("{{gameId}}", gameId);
}