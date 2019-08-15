import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nba_go/models/models.dart';
import 'player_info.dart';

class PlayerDetailBanner extends StatelessWidget {
  final PlayerDetail playerDetail;
  final Team playerTeam;

  const PlayerDetailBanner(
      {@required this.playerDetail, @required this.playerTeam})
      : assert(playerDetail != null),
        assert(playerTeam != null);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
          children: <Widget>[
            Positioned(
                child: PlayerInfo(
                    player: this.playerDetail.player, team: this.playerTeam),
                left: 15.0),
            Positioned(
              child: IconButton(
                  icon: Icon(LineIcons.angle_left),
                  color: Colors.white,
                  iconSize: 30.0,
                  onPressed: () => Navigator.pop(context)),
              top: 5,
              left: 5,
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            ));
  }
}
