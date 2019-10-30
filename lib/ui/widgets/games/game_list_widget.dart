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
  Timer _refreshTimer;
  bool _refresh;
  List<Game> _games;

  @override
  void initState() {
    this._refresh = false;
    this._refreshCompleter = Completer<void>();
    super.initState();
  }

  @override
  void dispose() {
    this._refreshTimer.cancel();
    super.dispose();
  }

  void _initializeTimer() {
    Timer.periodic(Duration(seconds: 15), (_) {
      this.setState(() {
        this._refresh = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GameListBloc gameListBloc = BlocProvider.of<GameListBloc>(context);
    if (this._refresh) {
      gameListBloc.dispatch(FetchGameList());
      this._refresh = false;
    }

    return BlocBuilder(
      bloc: gameListBloc,
      builder: (_, GameListState state) {
        if (state is GameListEmpty) {
          gameListBloc.dispatch(FetchGameList());
          return LoadingWidget();
        } else if (state is GameListLoading) {
          return (this._games != null) ? gameList() : LoadingWidget();
        } else if (state is GameListLoaded) {
          final List<Game> games = state.games;
          this._games = games;
          if(this._games.any((Game game) => game.status == GameStatus.PLAYING)) {
            this._initializeTimer();
          } else if(this._refreshTimer != null) {
            this._refreshTimer.cancel();
          }
          return gameList();
        } else if (state is GameListError) {
          print(state.error);
          return ErrorMessageWidget(error: 'Error loading game list');
        }
        return Text("Error unknown GameList State",
            style: TextStyle(color: Colors.red));
      },
    );
  }

  Widget gameList() {
    this._refreshCompleter?.complete();
    this._refreshCompleter = Completer<void>();
    return RefreshIndicator(
      child: (this._games.length > 0)
          ? ListView.builder(
              itemCount: this._games.length,
              itemBuilder: (context, index) {
                return GameCard(game: this._games[index]);
              })
          : Center(
              child: Text(
              'No games scheduled on this date',
              style: Theme.of(context).textTheme.body2,
            )),
      onRefresh: () {
        BlocProvider.of<GameListBloc>(context).dispatch(RefreshGameList());
        return this._refreshCompleter.future;
      },
    );
  }
}
