import 'package:flutter/material.dart';

import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/repositories/repositories.dart';
import 'package:nba_go/ui/app_scaffold.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

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

  // This will show BLoC state flow
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
          debugShowCheckedModeBanner: false,
          title: 'NBA Go!',
          theme: ThemeData( 
            fontFamily: 'Roboto',
            primaryColor: const Color(0xFF4A4849),
            accentColor: const Color(0xFFDFDCDE),
            backgroundColor: const Color(0xFFDFDCDE),
            focusColor: const Color(0xFFDFDCDE).withOpacity(0.3),
            toggleableActiveColor: Colors.white,
            textTheme: TextTheme(
              body1: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w200,
                color: const Color(0xFF4A4849),
                fontSize: 17.0
              ),
              body2: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w200,
                color: Colors.red,
                fontSize: 17.0
              ),
              title: TextStyle(
                fontFamily: 'OpenSansCondensed',
                fontSize: 24.0,
                fontStyle: FontStyle.italic,
                color: Colors.white
              ),
              subtitle: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w100,
                fontSize: 11.0,
                color: Color(0xFF4A4849)
              ),
              subhead: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w100,
                fontSize: 15.0,
                color: Color(0xFF4A4849)
              ),
              display1: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
                color: Color(0xFF4A4849)
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
              // we should have the teams with the preloaded action done
              TeamListBloc(teamListRepository: teamListRepository)..dispatch(FetchTeamList())
              ),
            ],
            child: SafeArea(
              child: AppScaffold()
            )
        )
    );
  }
}