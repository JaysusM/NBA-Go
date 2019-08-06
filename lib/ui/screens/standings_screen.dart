import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/blocs/standings_bloc.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/ui/widgets/widgets.dart';

class StandingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StandingListBloc standingListBloc =
        BlocProvider.of<StandingListBloc>(context);

    return BlocBuilder(
      bloc: standingListBloc,
      builder: (BuildContext context, StandingListState state) {
        if (state is StandingListEmpty) {
          standingListBloc.dispatch(FetchStandingList());
          return LoadingWidget();
        } else if (state is StandingListLoading)
          return LoadingWidget();
        else if (state is StandingListLoaded)
          return StandingsScreenView(standings: state.standings);
        else if (state is StandingListError)
          return ErrorMessageWidget(error: state.error);
        return ErrorMessageWidget(error: 'Unknown state $state');
      },
    );
  }
}

class StandingsScreenView extends StatefulWidget {
  final List<TeamStanding> standings;

  StandingsScreenView({@required this.standings}) : assert(standings != null);

  @override
  State<StatefulWidget> createState() => StandingsScreenViewState();
}

class StandingsScreenViewState extends State<StandingsScreenView> {
  Conference selectedConference;
  static const TEAMS_PER_CONFERENCE = 15;

  @override
  void initState() {
    super.initState();
    this.selectedConference = Conference.EAST;
  }

  @override
  Widget build(BuildContext context) {
    TeamListBloc teamListBloc = BlocProvider.of<TeamListBloc>(context);
    List<Team> teamList = (teamListBloc.currentState as TeamListLoaded).teams;
    List<TeamStanding> selectedConferenceTeams = widget.standings
        .where((teamStanding) =>
            teamStanding.conference == this.selectedConference)
        .toList();
    Set<TeamStanding> orderedTeams = Set();

    for (int i = 1; i <= TEAMS_PER_CONFERENCE; i++) {
      orderedTeams.add(selectedConferenceTeams
          .firstWhere((teamStanding) => teamStanding.confRank == i));
    }

    Iterator<TeamStanding> teamIterator = orderedTeams.iterator;

    return Column(
      children: <Widget>[
        Container(
          height: 250.0,
          margin: EdgeInsets.only(top: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _topThreeTeamsView(teamIterator, teamList)
          ),
        )
      ],
    );
  }

  String _getNextLogoPath(Iterator<TeamStanding> iterator, List<Team> teams) {
    iterator.moveNext();
    Team team =
        teams.firstWhere((team) => iterator.current.teamId == team.teamId);
    return "assets/logos/${team.tricode.toUpperCase()}.png";
  }

  List<Widget> _topThreeTeamsView(
      Iterator<TeamStanding> teamIterator, List<Team> teamList) {
    List<Widget> widgetList = List<Widget>();
    int startFlexSize = 20;
    for (int i = 1; i <= 3; i++) {
      widgetList.add(
        Expanded(
          child: Column(children: <Widget>[
            Image.asset(_getNextLogoPath(teamIterator, teamList),
                height: 150.0),
            Container(height: 15.0),
            Text("$i",
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontSize: 30.0)),
            Text("(${teamIterator.current.win}-${teamIterator.current.loss})",
                style: Theme.of(context).textTheme.body2)
          ]),
          flex: startFlexSize - (i + 1),
        ),
      );
    }
    return widgetList;
  }
}
