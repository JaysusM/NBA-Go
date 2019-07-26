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
    final String gameListURL = (date == null) 
      ? '$baseURL${nbaLinks.todayScoreboard}'
      : '$baseURL${nbaLinks.scoreboard(date)}';
    //Local Develop URL
    //final String gameListURL = 'http://192.168.1.41:8000/scoreboard.json';
    final gameListResponse = await this.httpClient.get(gameListURL);
    if (gameListResponse.statusCode != 200) {
      print('Received response status: ${gameListResponse.statusCode}, we returned empty game list');
      return List<Game>();
    }
    
    final gameListJSON = jsonDecode(gameListResponse.body);
    List<Game> games = new List<Game>();
    gameListJSON['games'].forEach((game) => games.add(Game.fromJSON(game)));
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

    final playerListJSON = jsonDecode(playerListReponse.body);
    List<Player> players = List<Player>();
    playerListJSON['league']['standard'].forEach((player) => players.add(Player.fromJSON(player)));
    return players;
  }

  Future<Map<String, dynamic>> getNBALinksJSON() async {
    final String nbaLinksURL = '$baseURL/10s/prod/v1/today.json';
    final nbaLinksResponse = await this.httpClient.get(nbaLinksURL);
    if (nbaLinksResponse.statusCode != 200)
      throw Exception('Error getting nba links');
    
    return jsonDecode(nbaLinksResponse.body);
  }
}