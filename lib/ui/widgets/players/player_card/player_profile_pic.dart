import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/team_list_bloc.dart';
import 'package:nba_go/models/models.dart';

class PlayerProfilePic extends StatelessWidget {

  final String playerId, teamId;
  PlayerProfilePic({@required this.playerId, @required this.teamId})
    : assert(playerId != null),
      assert(teamId != null);

  @override
  Widget build(BuildContext context) {
    String playerImageURL = NBALinks.getPlayerProfilePic(playerId);
    Team playerTeam =
      (BlocProvider.of<TeamListBloc>(context).currentState as TeamListLoaded)
          .teams
          .firstWhere((team) => team.teamId == teamId);

    return Stack(
      children: <Widget>[
        FadeInImage.assetNetwork(
            fadeOutCurve: Curves.linear,
            fadeOutDuration: Duration(milliseconds: 600),
            image: playerImageURL,
            placeholder: 'assets/player_placeholder.png'),
        Positioned(
          child: SizedBox(
            child: Image.asset(
                'assets/logos/${playerTeam.tricode.toUpperCase()}.png',
                fit: BoxFit.contain),
            height: 30
          ),
          top: 5.0,
          left: 5.0,
        ),
      ],
    );
  }
}