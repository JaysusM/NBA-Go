import 'package:flutter/material.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/ui/widgets/players/player_stats/single_stat_widget.dart';

class PlayerStats extends StatelessWidget {
  final PlayerDetail playerDetail;
  static const double BORDER_WIDTH = 3.0;

  PlayerStats({@required this.playerDetail}) : assert(playerDetail != null);

  @override
  Widget build(BuildContext context) {
    SeasonStats currentSeasonStats;
    try {
      currentSeasonStats = playerDetail.allSeasonStats[0];
    } catch (exception) {
      currentSeasonStats = null;
    }
    if (currentSeasonStats?.seasonYear != playerDetail.currentSeasonStats.seasonYear) {
      currentSeasonStats = playerDetail.currentSeasonStats;
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
                child: SingleStatWidget(
                    name: 'PPG', value: currentSeasonStats.ppg),
                flex: 1),
            Expanded(
                child: SingleStatWidget(
                    name: 'RPG', value: currentSeasonStats.rpg),
                flex: 1),
            Expanded(
                child: SingleStatWidget(
                    name: 'APG', value: currentSeasonStats.apg),
                flex: 1),
          ],
        ),
        Container(height: BORDER_WIDTH),
        Row(
          children: <Widget>[
            Expanded(
                child: SingleStatWidget(
                    name: 'SPG', value: currentSeasonStats.spg),
                flex: 1),
            Expanded(
                child: SingleStatWidget(
                    name: 'BPG', value: currentSeasonStats.bpg),
                flex: 1),
            Expanded(
                child: SingleStatWidget(
                    name: 'TOPG', value: currentSeasonStats.topg),
                flex: 1),
          ],
        )
      ]),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Theme.of(context).backgroundColor,
                  width: BORDER_WIDTH),
              bottom: BorderSide(
                  color: Theme.of(context).backgroundColor,
                  width: BORDER_WIDTH)),
          color: Theme.of(context).backgroundColor),
      padding: EdgeInsets.symmetric(horizontal: 12.5),
    );
  }
}
