import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/models/models.dart';

import 'widgets.dart';

class TeamSelector extends StatefulWidget {
  TeamSelector({Key key}) : super(key: key);

  _TeamSelectorState createState() => _TeamSelectorState();
}

class _TeamSelectorState extends State<TeamSelector> {
  @override
  Widget build(BuildContext context) {
    TeamListBloc teamListBloc =  BlocProvider.of<TeamListBloc>(context);
    return BlocBuilder(
      bloc: teamListBloc,
      builder: (BuildContext context, TeamListState state) {
        if (state is TeamListEmpty)
          return LoadingWidget();
        else if (state is TeamListLoading)
          return LoadingWidget();
        else if (state is TeamListLoaded) {
          List<Team> teams = state.teams;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: teams.length,
            itemBuilder: (BuildContext context, int index) => _teamCircle(teams[index], MediaQuery.of(context).size)
          );
        } else
          return Center(
            child: Text(
              'Error. Unknown state of TeamListBloc: $state',
              style: Theme.of(context).textTheme.body2,
            ),
          );
      },
    );
  }

  Widget _teamCircle(Team team, Size size) {
    return (team.isNBAFranchise) 
    ? Container(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.asset(
          "assets/logos/${team.tricode.toLowerCase()}.gif",
          fit: BoxFit.contain,
        ),
      ),
      height: size.height*0.12,
      width: size.width*0.12,
      margin: EdgeInsets.all(5.0),
    ) 
    : Container();
  }
}