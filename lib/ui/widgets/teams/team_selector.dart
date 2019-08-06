import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/models/models.dart';

import '../widgets.dart';

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

          return TeamSelectorView(teams: teams, selectedTeam: BlocProvider.of<PlayerListBloc>(context).selectedTeam);
        } else
          return ErrorWidget('Error. Unknown state of TeamListBloc: $state');
      }
    );
  }
}

class TeamSelectorView extends StatefulWidget {
  final List<Team> teams;
  final Team selectedTeam;
  
  TeamSelectorView({@required this.teams, @required this.selectedTeam})
    : assert(teams != null);

  _TeamSelectorViewState createState() => _TeamSelectorViewState();
}

class _TeamSelectorViewState extends State<TeamSelectorView> {

  Team _selectedTeam;
  int _selectedIndex;
  ScrollController _scrollController;
  static const double ITEM_SIZE = 40.0;
  static const double WIDTH_MARGIN = 5.0;

  @override
  void initState() { 
    this._selectedTeam = widget.selectedTeam;
    this._selectedIndex = max(widget.teams.indexOf(widget.selectedTeam), 0);
    this._scrollController = ScrollController(initialScrollOffset: this._calculateSelectedOptionOffset());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Team> teams = widget.teams;
    return ListView.builder(
      controller: this._scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: teams.length,
      itemBuilder: (BuildContext context, int index) {
        PlayerListBloc playerListBloc = BlocProvider.of<PlayerListBloc>(context);
        return _teamCircle(teams[index], index, playerListBloc, nbaLogo: teams[index] == null);
      } 
    );
  }

  Widget _teamCircle(Team team, int index, PlayerListBloc playerListBloc, {bool nbaLogo}) {
    return Container(
        child: InkWell(
          child: Image.asset(
            "assets/logos/${(nbaLogo != null && nbaLogo) ? 'nba.gif' : team.tricode.toUpperCase() + '.png'}",
            fit: BoxFit.contain,
          ),
          onTap: () {
            this.setState(() {
              this._selectedIndex = index;
              this._selectedTeam = team;
            });
            this._scrollController.animateTo(
                _calculateSelectedOptionOffset(),
                duration: Duration(milliseconds: 500),
                curve: Curves.elasticInOut
            );
            playerListBloc.dispatch(FilterPlayerListByTeam(team));
          },
        ),
      height: ITEM_SIZE,
      width: ITEM_SIZE,
      margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: WIDTH_MARGIN),
      decoration: BoxDecoration(
        color: (this._selectedTeam == team) ? Theme.of(context).toggleableActiveColor : Colors.white,
        borderRadius: BorderRadius.circular(5.0)
      ),
    );
  }

  double _calculateSelectedOptionOffset() {
    return max((this._selectedIndex-3), 0)*(ITEM_SIZE+WIDTH_MARGIN*2);
  }
}