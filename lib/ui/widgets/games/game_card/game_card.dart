import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/game_stats.dart';
import 'package:nba_go/ui/screens/screens.dart';
import 'package:nba_go/ui/widgets/widgets.dart';

import 'game_info.dart';
import 'team_row.dart';
import 'package:flutter/material.dart';
import 'package:nba_go/models/models.dart';

class GameCard extends StatelessWidget {
  final Game game;

  GameCard({@required this.game}) : assert(game != null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          child: Row(children: <Widget>[
            Expanded(
              child: GameInfo(
                  gameStatus: game.status,
                  clock: game.clock,
                  period: game.period,
                  startTime: game.startTime),
              flex: 2,
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  TeamRow(team: game.vTeam, gameStatus: game.status),
                  Divider(
                      height: 1.5, color: Theme.of(context).backgroundColor),
                  TeamRow(team: game.hTeam, gameStatus: game.status)
                ],
              ),
              flex: 8,
            )
          ]),
          decoration: BoxDecoration(color: Colors.white),
          margin: EdgeInsets.only(bottom: 2.5),
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.5),
        ),
        onTap: () => (game.status == GameStatus.NOTSTARTED) ? null : _showGameDetail(context));
  }

  void _showGameDetail(BuildContext parentContext) {
    Navigator.of(parentContext)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      String gameDate = this.game.gameDate;
      String gameId = this.game.gameId;
      BlocProvider.of<GameStatsBloc>(parentContext)
          .dispatch(FetchGameStats(gameDate: gameDate, gameId: gameId));
      return BlocBuilder(
        bloc: BlocProvider.of<GameStatsBloc>(parentContext),
        builder: (BuildContext context, GameStatsState state) {
          if (state is GameStatsLoading)
            return LoadingWidget();
          else if (state is GameStatsLoaded)
            return GameDetailScreen(state.gameStats);
          else if (state is GameStatsError) return ErrorWidget(state.error);
          return ErrorWidget("ERROR. It was not possible to load game stats.");
        },
      );
    }));
  }
}
