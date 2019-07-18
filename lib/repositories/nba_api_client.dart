import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:nba_go/models/models.dart';

class NBAApiClient {
  static const baseURL = 'https://data.nba.net/prod/v1';
  final http.Client httpClient;

  NBAApiClient({@required this.httpClient}): assert(httpClient != null);

  Future<List<Game>> fetchGameList() async {
    final gameListURL = '$baseURL/20190503/scoreboard.json';
    final gameListResponse = await this.httpClient.get(gameListURL);

    if(gameListResponse.statusCode != 200)
      throw Exception('Error getting game list');
    
    final gameListJSON = jsonDecode(gameListResponse.body);
    List<Game> games = new List<Game>();
    gameListJSON['games'].forEach((game) => games.add(Game.fromJSON(game)));
    return games;
  }
}