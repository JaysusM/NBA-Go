import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:nba_go/blocs/team_list_bloc.dart';
import 'package:nba_go/repositories/game_list_repository.dart';
import 'package:nba_go/blocs/game_list_bloc.dart';
import 'package:nba_go/repositories/nba_api_client.dart';
import 'package:nba_go/repositories/team_list_repository.dart';
import 'package:nba_go/widgets/game_list_widget.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  final NBAApiClient nbaApiClient = NBAApiClient(
      httpClient: http.Client(),
  );  

  final GameListRepository gameListRepository = GameListRepository(nbaApiClient: nbaApiClient);
  final TeamListRepository teamListRepository = TeamListRepository(nbaApiClient: nbaApiClient);

  // This will show state flow
  // BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App(gameListRepository: gameListRepository, teamListRepository: teamListRepository));
}

class App extends StatelessWidget {
  final GameListRepository gameListRepository;
  final TeamListRepository teamListRepository;

  App({Key key, @required this.gameListRepository, @required this.teamListRepository})
      : assert(gameListRepository != null),
        assert(teamListRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'NBA GO!',
          theme: ThemeData( 
            fontFamily: 'Roboto',
            primaryColor: const Color(0xFF4A4849),
            accentColor: const Color(0XFF94926D),
            backgroundColor: const Color(0xFFDFDCDE),
            textTheme: TextTheme(
              body1: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w200
              )
            )
          ),
          home: MultiBlocProvider(
            providers: [
              BlocProvider<GameListBloc>(builder: (context) =>
                GameListBloc(gameListRepository: gameListRepository)
                ),
              BlocProvider<TeamListBloc>(builder: (context) =>
              // ..dispatch will dispatch the event FetchTeamList so wherever we use this Bloc
              // we will have the teams with the preloaded action done
                TeamListBloc(teamListRepository: teamListRepository)..dispatch(FetchTeamList())
              ),
            ],
            child: Scaffold(
              appBar: AppBar(title: Text('NBA Go!')),
              body: GameListView(gameListRepository: gameListRepository)
            )
          ),
        );
  }
}