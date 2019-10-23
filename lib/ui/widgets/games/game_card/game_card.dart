import 'package:nba_go/ui/screens/screens.dart';
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
      return GameDetailScreen(gameDate, gameId);
    }));
  }
}
