import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/game_list_bloc.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/repositories/game_list_repository.dart';

import 'game_card.dart';

class GameListView extends StatefulWidget {

  final GameListRepository gameListRepository;

  GameListView({@required this.gameListRepository})
    : assert(gameListRepository != null);

  @override
  State<StatefulWidget> createState() => GameListViewState();
}

class GameListViewState extends State<GameListView> {
  GameListBloc _gameListBloc;

  @override
  void initState() {
    this._gameListBloc = GameListBloc(gameListRepository: widget.gameListRepository);
    super.initState();
  }

  @override
  void dispose() {
    this._gameListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: BlocBuilder(
          bloc: _gameListBloc,
          builder: (_, GameListState state) {
            if (state is GameListEmpty) {
              _gameListBloc.dispatch(FetchGameList());
              return Center(child: Text('No games loaded'));
            } else if (state is GameListLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GameListLoaded) {
              final List<Game> games = state.games;
              return ListView.builder(
                itemCount: games.length,
                itemBuilder: (context, index) {
                  return GameCard(game: games[index]);
                },
              );
            } else {
              return Center(child: Text('Error loading data', style: TextStyle(color: Colors.red)));
            }
          },
        ),
        color: Theme.of(context).backgroundColor,
      );
  }

}