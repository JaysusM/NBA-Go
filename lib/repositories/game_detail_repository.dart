import 'package:meta/meta.dart';

import 'nba_api_client.dart';
import 'package:nba_go/models/models.dart';

class GameDetailRepository {
  final NBAApiClient nbaApiClient;

  GameDetailRepository({@required this.nbaApiClient})
    : assert(nbaApiClient != null);

  Future<GameDetail> getGameDetail(String gameDate, String gameId) async {
    return nbaApiClient.fetchGameDetail(gameDate, gameId);
  }
}