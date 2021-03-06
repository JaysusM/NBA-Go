import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'package:nba_go/models/models.dart';

class NBAApiClient {
  static const baseURL = 'https://data.nba.net';
  final http.Client httpClient;

  NBAApiClient({@required this.httpClient}): assert(httpClient != null);

  Future<List<Game>> fetchGameListWithDate(DateTime date) async {
    return fetchGameList(date: DateFormat('yyyyMMdd').format(date));
  }

  Future<List<Game>> fetchGameList({String date}) async {
    final NBALinks nbaLinks = await NBALinks.nbaLinks;
    date = (date == null) ? nbaLinks.date : date;
    final String gameListURL = '$baseURL${nbaLinks.scoreboard(date)}';

    final gameListResponse = await this.httpClient.get(gameListURL);
    if (gameListResponse.statusCode != 200) {
      print('Received response status: ${gameListResponse.statusCode}, we returned empty game list');
      return List<Game>();
    }
    
    final gameListJSON = jsonDecode(gameListResponse.body);
    List<Game> games = new List<Game>();
    gameListJSON['games'].forEach((game) => games.add(Game.fromJSON(date, game)));
    return games;
  }

  Future<List<Team>> fetchTeamList() async {
    final NBALinks nbaLinks = await NBALinks.nbaLinks;
    final String teamsURL = '$baseURL${nbaLinks.teams}';
    final teamListResponse = await this.httpClient.get(teamsURL);
    if (teamListResponse.statusCode != 200)
      throw Exception('Error getting team list');
    
    final teamListJSON = jsonDecode(teamListResponse.body);
    List<Team> teams = new List<Team>();
    teamListJSON['league']['standard'].forEach((team) => teams.add(Team.fromJSON(team)));
    return teams;
  }

  Future<List<Player>> fetchPlayerList() async {
    final NBALinks nbaLinks = await NBALinks.nbaLinks;
    final String playersURL = '$baseURL${nbaLinks.players}';
    final playerListReponse = await this.httpClient.get(playersURL);
    if(playerListReponse.statusCode != 200)
      throw Exception('Error getting player list');

    final Map<String, dynamic> playerListJSON = jsonDecode(playerListReponse.body);
    List<Player> players = List<Player>();
    playerListJSON['league']['standard'].forEach((player) => players.add(Player.fromJSON(player)));
    return players;
  }

  Future<GameDetail> fetchGameDetail(String date, String gameId) async {
    final NBALinks nbaLinks = await NBALinks.nbaLinks;
    final String gameDetailURL = '$baseURL${nbaLinks.gameStats(date, gameId)}';
    final gameDetailResponse = await this.httpClient.get(gameDetailURL);
    if(gameDetailResponse.statusCode != 200)
      throw Exception('Error getting game stats');

    final Map<String, dynamic> gameStatsJSON = jsonDecode(gameDetailResponse.body);
    GameDetail gameDetail = GameDetail.fromJSON(gameStatsJSON);
    return gameDetail;
  }

  Future<PlayerDetail> fetchPlayerDetail({Player player}) async {
    final NBALinks nbaLinks = await NBALinks.nbaLinks;
    final String playerProfileSuffix = nbaLinks.playerProfile.replaceAll('{{personId}}', player.personId);
    final String playerDetailsURL = '$baseURL$playerProfileSuffix';
    final playerDetailReponse = await this.httpClient.get(playerDetailsURL);

    if(playerDetailReponse.statusCode != 200)
      throw Exception('Error getting player details for player: ${player.personId}');
    
    final Map<String, dynamic> playerDetailJSON = jsonDecode(playerDetailReponse.body);
    return PlayerDetail.fromJSON(playerDetailJSON, player);
  }

  Future<List<PlayoffsSeries>> fetchPlayoffSeries() async {
    final NBALinks nbaLinks = await NBALinks.nbaLinks;
    const int PLAYOFFS_STAGE = 4;
    if (nbaLinks.stage == PLAYOFFS_STAGE) {
      final String playoffsSeriesURL = '$baseURL${nbaLinks.playoffsBracket}';
      final playoffsBracketResponse = await this.httpClient.get(playoffsSeriesURL);
      if (playoffsBracketResponse.statusCode != 200)
        throw new Exception('Error getting playoffs bracket');

      final Map<String, dynamic> playoffsSeriesJSON = jsonDecode(playoffsBracketResponse.body);
      List<PlayoffsSeries> playoffsSeries = List<PlayoffsSeries>();
      playoffsSeriesJSON['series'].forEach((serie) => playoffsSeries.add(PlayoffsSeries.fromJSON(serie)));
      return playoffsSeries;
    }

    return [];
  }

  Future<List<TeamStanding>> fetchConferenceStandings() async {
    final NBALinks nbaLinks = await NBALinks.nbaLinks;
    final String standingsConferenceURL = '$baseURL${nbaLinks.standingsConference}';
    final standingsResponse = await this.httpClient.get(standingsConferenceURL);
    if(standingsResponse.statusCode != 200)
      throw Exception('Error getting conference standings list');

    final Map<String, dynamic> teamStandingJSON = jsonDecode(standingsResponse.body);
    List<TeamStanding> teamStandingList = List<TeamStanding>();
    int index = 0;

    teamStandingJSON['league']['standard']['conference']['east'].forEach(
      (team) => 
        teamStandingList.add(TeamStanding.fromJSON(team, Conference.EAST, ++index))
    );

    index = 0;

    teamStandingJSON['league']['standard']['conference']['west'].forEach(
      (team) => 
        teamStandingList.add(TeamStanding.fromJSON(team, Conference.WEST, ++index))
    );
    return teamStandingList;
  }

  Future<Map<String, dynamic>> getNBALinksJSON() async {
    final String nbaLinksURL = '$baseURL/10s/prod/v1/today.json';
    final nbaLinksResponse = await this.httpClient.get(nbaLinksURL);
    if (nbaLinksResponse.statusCode != 200)
      throw Exception('Error getting nba links');
    
    return jsonDecode(nbaLinksResponse.body);
  }
}