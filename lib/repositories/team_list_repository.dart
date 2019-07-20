import 'package:meta/meta.dart';

import 'nba_api_client.dart';
import 'package:nba_go/models/models.dart';

class TeamListRepository {
  final NBAApiClient nbaApiClient;

  TeamListRepository({@required this.nbaApiClient})
    : assert(nbaApiClient != null);

  Future<List<Team>> getTeamList() async {
    return nbaApiClient.fetchTeamList();
  }
}