import 'nba_api_client.dart';
import 'package:meta/meta.dart';
import 'package:nba_go/models/models.dart';

class StandingsRepository {
  final NBAApiClient nbaApiClient;

  StandingsRepository({@required this.nbaApiClient})
    : assert(nbaApiClient != null);

  Future<List<TeamStanding>> fetchConferenceStandings() async {
    return nbaApiClient.fetchConferenceStandings();
  }

  Future<List<PlayoffsSeries>> fetchPlayoffsSeries() async {
    return nbaApiClient.fetchPlayoffSeries();
  }
}