import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/ui/widgets/widgets.dart';

class GameListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GameListViewState();
}

class GameListViewState extends State<GameListView> {
  Completer _refreshCompleter;

  @override
  void initState() {
    this._refreshCompleter = Completer<void>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: BlocProvider.of<GameListBloc>(context),
        builder: (_, GameListState state) {
          if (state is GameListEmpty) {
            BlocProvider.of<GameListBloc>(context).dispatch(FetchGameList());
            return LoadingWidget();
          } else if (state is GameListLoading) {
            return LoadingWidget();
          } else if (state is GameListLoaded) {
            final List<Game> games = state.games;
            this._refreshCompleter?.complete();
            this._refreshCompleter = Completer<void>();
            return RefreshIndicator(
              child: (games.length > 0) 
                ? ListView.builder(
                itemCount: games.length,
                itemBuilder: (context, index) {
                  return GameCard(game: games[index]);
                })
                : Center(
                  child: Text(
                    'No games scheduled on this date',
                    style: Theme.of(context).textTheme.body2,
                  )
                )
              ,
              onRefresh: () {
                BlocProvider.of<GameListBloc>(context).dispatch(RefreshGameList());
                return this._refreshCompleter.future;
              },
            );
          } else if (state is GameListError) {
            print(state.error);
            return ErrorMessageWidget(error: 'Error loading game list');
          }
          return Text("Error unknown GameList State", style: TextStyle(color: Colors.red));
        },
      );
  }

}