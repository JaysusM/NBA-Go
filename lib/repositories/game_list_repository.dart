import 'package:meta/meta.dart';

import 'nba_api_client.dart';
import 'package:nba_go/models/models.dart';

class GameListRepository {
  final NBAApiClient nbaApiClient;

  GameListRepository({@required this.nbaApiClient})
    : assert(nbaApiClient != null);

  Future<List<Game>> getGameList() async {
    return nbaApiClient.fetchGameList();
  }
}