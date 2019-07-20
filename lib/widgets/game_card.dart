import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/team_list_bloc.dart';
import 'package:nba_go/models/models.dart';

class GameCard extends StatelessWidget {

  final Game game;

  GameCard({@required this.game})
    : assert(game != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TeamRow(team: game.vTeam),
          Divider(height: 1.5, color: Colors.grey),
          TeamRow(team: game.hTeam)
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white
      ),
      margin: EdgeInsets.only(bottom: 15.0),
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.5),
    );
  }
}

class TeamRow extends StatelessWidget {
  final GameTeam team;

  TeamRow({@required this.team})
    : assert(team != null);

  @override
  Widget build(BuildContext context) {
    TeamListBloc teamListBloc = BlocProvider.of<TeamListBloc>(context);
    return 
      BlocBuilder(
        bloc: teamListBloc,
        builder: (BuildContext context, TeamListState state) {
          if(state is TeamListEmpty) {
            print('Empty');
            print(team.tricode);
            teamListBloc.dispatch(FetchTeamList());
            return Center(
              child: Text('No teams loaded')
              );
          } else if (state is TeamListLoading) {
            print('${team.tricode}Loading');
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
                      style: TextStyle(color: Colors.black)
                    ),
                    alignment: Alignment.centerLeft
                  ),
                  Align(
                    child: Text(
                      team.score.toString(),
                      style: TextStyle(color: Colors.black)
                    ),
                    alignment: Alignment.centerRight
                  )
                ],
              )
            );
          } else {
            return Center(
              child: Text(
                  'Error loading team data'
                ),
              );
          }
        },
      );
  }
}