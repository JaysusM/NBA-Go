import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/models/models.dart';

import 'widgets.dart';

class TeamSelector extends StatelessWidget {
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
          // The null is to add a 'All NBA Team' as first element
          List<Team> teams = state.teams
            .where((team) => (team != null) && team.isNBAFranchise)
            .toList();
          teams.insert(0, null);
          return TeamSelectorView(teams: teams);
        } else
          return ErrorWidget('Error. Unknown state of TeamListBloc: $state');
      }
    );
  }
}

class TeamSelectorView extends StatefulWidget {
  final List<Team> teams;
  
  TeamSelectorView({@required this.teams})
    : assert(teams != null);

  _TeamSelectorViewState createState() => _TeamSelectorViewState();
}

class _TeamSelectorViewState extends State<TeamSelectorView> {

  int _selectedIndex;
  ScrollController _scrollController;
  static const double ITEM_SIZE = 40.0;

  @override
  void initState() { 
    this._scrollController = ScrollController();
    this._selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Team> teams = widget.teams;
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: teams.length,
      itemBuilder: (BuildContext context, int index) {
        PlayerListBloc playerListBloc = BlocProvider.of<PlayerListBloc>(context);
        return _teamCircle(teams[index], index, playerListBloc, nbaLogo: teams[index] == null);
      } 
    );
  }

  Widget _teamCircle(Team team, int index, PlayerListBloc playerListBloc, {bool nbaLogo}) {
    double widthMargin = 5.0;
    
    return Container(
        child: InkWell(
          child: Image.asset(
            "assets/logos/${(nbaLogo != null && nbaLogo) ? 'nba' : team.tricode.toLowerCase()}.gif",
            fit: BoxFit.contain,
          ),
          onTap: () {
            this.setState(() {
              this._selectedIndex = index;
              this._scrollController.animateTo(
                index*((ITEM_SIZE-3)+widthMargin*2),
                duration: Duration(milliseconds: 500),
                curve: Curves.elasticInOut
              );
            });
            playerListBloc.dispatch(FilterPlayerListByTeam(team));
          },
        ),
      height: ITEM_SIZE,
      width: ITEM_SIZE,
      margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: widthMargin),
      decoration: BoxDecoration(
        color: (this._selectedIndex == index) ? Theme.of(context).toggleableActiveColor : Colors.white,
        borderRadius: BorderRadius.circular(5.0)
      ),
    );
  }
}