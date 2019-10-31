import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/models/models.dart';
import 'player_profile_pic.dart';
import '../../../screens/screens.dart';

import 'player_info.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  PlayerCard({@required this.player}) : assert(player != null);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      child: Card(
          child: Row(
        children: <Widget>[
          PlayerProfilePic(playerId: player.personId, teamId: player.teamId),
          Container(child: PlayerInfo(player: player), margin: EdgeInsets.only(left: 10.0)),
          Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(child: 
                           RotatedBox(
                            child: Text('Stats', style: textTheme.display1),
                            quarterTurns: 3,
                            ),
                            margin: EdgeInsets.fromLTRB(5.0, 0.0, 7.5, 0.0),
                          ),
                          Icon(LineIcons.arrow_right, color: textTheme.display1.color)
                        ],
                      ),
                      height: 100.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                          color: Theme.of(context).toggleableActiveColor,
                          //Radius.circular(4.0) is the Card's default radius
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4.0),
                              bottomRight: Radius.circular(4.0))),
                    ),
                    onTap: () => 
                      this._showPlayerDetailPage(context)
                    )),
          )
        ],
      )),
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
    );
  }

  void _showPlayerDetailPage(BuildContext parentContext) {
    Navigator.of(parentContext).push(CupertinoPageRoute(
      builder: (_) => PlayerDetailScreen(player: this.player)
    ));
  }
}
