import 'nba_api_client.dart';
import 'package:meta/meta.dart';
import 'package:nba_go/models/models.dart';

class PlayerListRepository {
  final NBAApiClient nbaApiClient;

  PlayerListRepository({@required this.nbaApiClient})
    : assert(nbaApiClient != null);

  Future<List<Player>> fetchPlayerList() async {
    return nbaApiClient.fetchPlayerList();
  }
}