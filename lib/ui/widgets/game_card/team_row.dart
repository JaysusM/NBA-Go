import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/team_list_bloc.dart';
import 'package:nba_go/models/models.dart';

import '../widgets.dart';

class TeamRow extends StatelessWidget {
  final GameTeam team;
  final GameStatus gameStatus;

  TeamRow({@required this.team, @required this.gameStatus})
    : assert(team != null),
      assert(gameStatus != null);

  @override
  Widget build(BuildContext context) {
    TeamListBloc teamListBloc = BlocProvider.of<TeamListBloc>(context);
    TextStyle textStyle = Theme.of(context).textTheme.body1;    
    double logoWidth = textStyle.fontSize + 5;

    if(this.gameStatus == GameStatus.FINISHED && team.isWinner)
      textStyle = textStyle.copyWith(fontWeight: FontWeight.w300);

    return BlocBuilder(
      bloc: teamListBloc,
      builder: (BuildContext context, TeamListState state) {
        if(state is TeamListEmpty) {
          teamListBloc.dispatch(FetchTeamList());
          return Center(
            child: Text('No teams loaded')
            );
        } else if (state is TeamListLoading) {
          return LoadingWidget();
        } else if (state is TeamListLoaded) {
          List<Team> teams = state.teams;
          Team rowTeam = teams.firstWhere((team) => team.teamId == this.team.teamId);
          return Container(
            margin: EdgeInsets.all(5.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Align(
                  child: Row(
                    children: <Widget>[ 
                      Image.asset("assets/logos/${
                        (rowTeam.isNBAFranchise) ? rowTeam.tricode.toLowerCase() : 'nba'
                        }.gif", width: logoWidth
                      ),
                      Container(width: 5.0),
                      Text(
                        rowTeam.fullName,
                        style: textStyle
                      )
                    ],
                  ),
                  alignment: Alignment.centerLeft
                ),
                Align(
                  child: Text(
                    team.score.toString(),
                    style: textStyle
                  ),
                  alignment: Alignment.centerRight
                )
              ],
            )
          );
        } else if(state is TeamListError) {
          print(state.error);
          return ErrorMessageWidget(error: 'Error loading team list');
        }

        return ErrorMessageWidget(error: 'Error unknown TeamList State');
      },
    );
  }
}