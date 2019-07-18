import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:nba_go/repositories/game_list_repository.dart';
import 'package:nba_go/blocs/game_list_bloc.dart';
import 'package:nba_go/repositories/nba_api_client.dart';
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
  final GameListRepository gameListRepository = GameListRepository(
    nbaApiClient: NBAApiClient(
      httpClient: http.Client(),
    ),
  );
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
      App(gameListRepository: gameListRepository),
    );
}

class App extends StatelessWidget {
  final GameListRepository gameListRepository;

  App({Key key, @required this.gameListRepository})
      : assert(gameListRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'NBA GO!',
          theme: ThemeData.dark(),
          home: BlocProvider(
            builder: (context) =>
                GameListBloc(gameRepository: gameListRepository),
            child: Scaffold(
              appBar: AppBar(title: Text('NBA Go!')),
              body: GameListView(gameListRepository: gameListRepository)
            )
          ),
        );
  }
}