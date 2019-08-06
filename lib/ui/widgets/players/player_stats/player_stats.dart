import 'package:flutter/material.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/ui/widgets/players/player_stats/single_stat_widget.dart';

class PlayerStats extends StatelessWidget {
  final PlayerDetail playerDetail;

  PlayerStats({@required this.playerDetail}) : assert(playerDetail != null);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          children: <Widget>[
            Expanded(
                child: SingleStatWidget(
                    name: 'PPG', value: playerDetail.currentSeasonStats.ppg),
                flex: 1),
            Expanded(
                child: SingleStatWidget(
                    name: 'APG', value: playerDetail.currentSeasonStats.apg),
                flex: 1),
            Expanded(
                child: SingleStatWidget(
                    name: 'RPG', value: playerDetail.currentSeasonStats.apg),
                flex: 1),
          ],
        ),
        color: Colors.red,
        margin: EdgeInsets.symmetric(horizontal: 12.5));
  }
}
