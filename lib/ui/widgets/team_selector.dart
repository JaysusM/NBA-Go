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
            itemCount: teams.length+1,
            //TODO Refactor this to add 'NBA' Team in first positions
            itemBuilder: (BuildContext context, int index) {
              Size size = MediaQuery.of(context).size;
              if (index > 0 && teams[index-1].isNBAFranchise)
                return _teamCircle(teams[index-1], size);
              else if (index == 0)
                return _teamCircle(null, size, nbaLogo: true);
              return Container();
            } 
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

  Widget _teamCircle(Team team, Size size, {bool nbaLogo}) {
    return Container(
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.3),
        child: Image.asset(
          "assets/logos/${(nbaLogo != null && nbaLogo) ? 'nba' : team.tricode.toLowerCase()}.gif",
          fit: BoxFit.cover,
        ),
      ),
      height: size.height*0.12,
      width: size.width*0.12,
      margin: EdgeInsets.all(5.0),
    );
  }
}