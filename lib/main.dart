import 'package:flutter/material.dart';

import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/blocs/standings_bloc.dart';
import 'package:nba_go/repositories/repositories.dart';
import 'package:nba_go/repositories/standings_repository.dart';
import 'package:nba_go/ui/app_scaffold.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  final NBAApiClient nbaApiClient = NBAApiClient(
    httpClient: http.Client(),
  );

  final GameListRepository gameListRepository =
      GameListRepository(nbaApiClient: nbaApiClient);
  final TeamListRepository teamListRepository =
      TeamListRepository(nbaApiClient: nbaApiClient);
  final PlayerListRepository playerListRepository =
      PlayerListRepository(nbaApiClient: nbaApiClient);
  final PlayerDetailRepository playerDetailRepository =
      PlayerDetailRepository(nbaApiClient: nbaApiClient);
  final StandingsRepository standingsRepository =
      StandingsRepository(nbaApiClient: nbaApiClient);
  final GameDetailRepository gameDetailRepository =
      GameDetailRepository(nbaApiClient: nbaApiClient);

  // This will show BLoC state flow
  // BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App(
      gameListRepository: gameListRepository,
      teamListRepository: teamListRepository,
      playerListRepository: playerListRepository,
      playerDetailRepository: playerDetailRepository,
      gameStatsRepository: gameDetailRepository,
      standingsRepository: standingsRepository));
}

class App extends StatelessWidget {
  final GameListRepository gameListRepository;
  final TeamListRepository teamListRepository;
  final PlayerListRepository playerListRepository;
  final PlayerDetailRepository playerDetailRepository;
  final StandingsRepository standingsRepository;
  final GameDetailRepository gameStatsRepository;

  App(
      {Key key,
      @required this.gameListRepository,
      @required this.teamListRepository,
      @required this.playerListRepository,
      @required this.playerDetailRepository,
      @required this.standingsRepository,
      @required this.gameStatsRepository})
      : assert(gameListRepository != null),
        assert(teamListRepository != null),
        assert(playerListRepository != null),
        assert(playerDetailRepository != null),
        assert(standingsRepository != null),
        assert(gameStatsRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<GameListBloc>(
              builder: (context) =>
                  GameListBloc(gameListRepository: gameListRepository)),
          BlocProvider<TeamListBloc>(
              builder: (context) =>
                  // ..dispatch will dispatch the event FetchTeamList so wherever we use this Bloc
                  // we should have the teams with the preloaded action done
                  TeamListBloc(teamListRepository: teamListRepository)
                    ..dispatch(FetchTeamList())),
          BlocProvider<PlayerListBloc>(
              builder: (context) =>
                  PlayerListBloc(playerListRepository: playerListRepository)
                    ..dispatch(FetchPlayerList())),
          BlocProvider<PlayerDetailBloc>(
              builder: (context) => PlayerDetailBloc(
                  playerDetailRepository: playerDetailRepository)),
          BlocProvider<StandingListBloc>(
              builder: (context) =>
                  StandingListBloc(standingRepository: standingsRepository)
                    ..dispatch(FetchStandingList())),
          BlocProvider<GameStatsBloc>(
              builder: (context) =>
                  GameStatsBloc(gameStatsRepository: gameStatsRepository))
        ],
        child: MaterialApp(
            //showPerformanceOverlay: true,
            debugShowCheckedModeBanner: false,
            title: 'NBA Go!',
            theme: ThemeData(
                fontFamily: 'Roboto',
                primaryColor: const Color(0xFF333349),
                accentColor: const Color(0xFF7E7F92),
                backgroundColor: const Color(0xFF333349),
                focusColor: const Color(0xFF7E7F92),
                toggleableActiveColor: const Color(0xFFEA3742),
                textTheme: TextTheme(
                  body1: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w200,
                      color: const Color(0xFF333349),
                      fontSize: 17.0),
                  caption: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w200,
                      color: Colors.red,
                      fontSize: 17.0),
                  body2: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                      fontSize: 17.0),
                  title: TextStyle(
                      fontFamily: 'OpenSansCondensed',
                      fontSize: 24.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                  subtitle: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w100,
                    fontSize: 11.0,
                    color: Colors.white,
                  ),
                  headline: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                  subhead: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w100,
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                  display1: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                )),
            home: SafeArea(
              child: AppScaffold(),
            )));
  }
}
