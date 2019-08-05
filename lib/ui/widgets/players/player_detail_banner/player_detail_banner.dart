import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nba_go/models/models.dart';
import 'player_info.dart';

class PlayerDetailBanner extends StatelessWidget {
  final PlayerDetail playerDetail;

  const PlayerDetailBanner({@required this.playerDetail})
      : assert(playerDetail != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 190.0,
        child: Stack(
          children: <Widget>[
            SizedBox(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: IconButton(
                          icon: Icon(LineIcons.angle_left),
                          color: Colors.white,
                          iconSize: 30.0,
                          onPressed: () => Navigator.pop(context)),
                      top: 5,
                      left: 5,
                    ),
                    Positioned(
                        child:
                            PlayerInfo(player: this.playerDetail.player),
                        left: 15.0)
                  ],
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                ),
              ),
              height: 190.0
            ),
          ],
        ));
  }
}
