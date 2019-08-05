import 'nba_api_client.dart';
import 'package:meta/meta.dart';
import 'package:nba_go/models/models.dart';

class PlayerDetailRepository {
  final NBAApiClient nbaApiClient;

  PlayerDetailRepository({@required this.nbaApiClient})
    : assert(nbaApiClient != null);

  Future<PlayerDetail> fetchPlayerDetail(Player player) async {
    return nbaApiClient.fetchPlayerDetail(player: player);
  }
}