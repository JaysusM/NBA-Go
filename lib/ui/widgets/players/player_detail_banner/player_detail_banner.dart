import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/models/models.dart';
import 'player_info.dart';

class PlayerDetailBanner extends StatelessWidget {
  final PlayerDetail playerDetail;

  const PlayerDetailBanner(
      {@required this.playerDetail})
      : assert(playerDetail != null);

  @override
  Widget build(BuildContext context) {
    List<Team> teams =
          (BlocProvider.of<TeamListBloc>(context).currentState as TeamListLoaded)
          .teams;

    Team playerTeam = teams.firstWhere((team) => team.teamId == this.playerDetail.player.teamId);
    return Container(
        child: Stack(
          children: <Widget>[
            Positioned(
                child: PlayerInfo(
                    player: this.playerDetail.player, team: playerTeam),
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
