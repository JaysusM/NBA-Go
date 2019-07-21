import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/team_list_bloc.dart';
import 'package:nba_go/models/models.dart';

class TeamRow extends StatelessWidget {
  final GameTeam team;

  TeamRow({@required this.team})
    : assert(team != null);

  @override
  Widget build(BuildContext context) {
    TeamListBloc teamListBloc = BlocProvider.of<TeamListBloc>(context);
    TextStyle textStyle = Theme.of(context).textTheme.body1;

    if(this.team.isWinner)
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
          return CircularProgressIndicator();
        } else if (state is TeamListLoaded) {
          List<Team> teams = state.teams;
          Team rowTeam = teams.firstWhere((team) => team.teamId == this.team.teamId);
          return Container(
            margin: EdgeInsets.all(5.0),
            child: Stack(
              children: <Widget>[
                Align(
                  child: Text(
                    rowTeam.fullName,
                    style: textStyle
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
          return Center(
            child: Text(
              'Error loading team data'
            ),
          );
        }

        return Text("Error unknown TeamList State", style: TextStyle(color: Colors.red));
      },
    );
  }
}