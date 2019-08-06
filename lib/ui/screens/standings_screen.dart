import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/blocs/standings_bloc.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/ui/widgets/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

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

    return AnimatedSwitcher(
        duration: Duration(seconds: 1),
        child: Container(
            key: ValueKey(selectedConference),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          child: SizedBox(
                              child: CircleAvatar(
                                  child: Image.asset('assets/logos/EAST.png',
                                      height: 60.0),
                                  backgroundColor:
                                      (selectedConference == Conference.EAST)
                                          ? Colors.white.withOpacity(0.4)
                                          : Colors.transparent),
                              height: 80.0,
                              width: 80.0),
                          onTap: () => this.setState(() {
                            this.selectedConference = Conference.EAST;
                          }),
                        ),
                        InkWell(
                          child: SizedBox(
                              child: CircleAvatar(
                                  child: Image.asset('assets/logos/WEST.png',
                                      height: 60.0),
                                  backgroundColor:
                                      (selectedConference == Conference.WEST)
                                          ? Colors.white.withOpacity(0.4)
                                          : Colors.transparent),
                              height: 80.0,
                              width: 80.0),
                          onTap: () => this.setState(() {
                            this.selectedConference = Conference.WEST;
                          }),
                        ),
                      ],
                    ),
                    color: Theme.of(context).backgroundColor,
                    height: 100.0),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(70, 80),
                      )),
                  height: 250.0,
                  padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: TopThreeTeamsStandings(
                      teamIterator: teamIterator, teamList: teamList),
                ),
                Expanded(
                    child: Container(
                        color: Colors.white,
                        child: ListView.builder(
                          // -3 Because we showed the three top teams before
                          itemCount: TEAMS_PER_CONFERENCE - 3,
                          itemBuilder: (BuildContext context, int index) {
                            TextStyle textStyle = Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(
                                    fontSize: 22.0,
                                    color: Theme.of(context).primaryColor);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text("${index + 4}", style: textStyle),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Image.asset(
                                      _getNextLogoPath(teamIterator, teamList),
                                      width: textStyle.fontSize,
                                      height: textStyle.fontSize),
                                  flex: 1,
                                ),
                                Expanded(flex: 2, child: Container()),
                                Expanded(
                                    flex: 7,
                                    child: Text(
                                        teamList
                                                .firstWhere((team) =>
                                                    teamIterator
                                                        .current.teamId ==
                                                    team.teamId)
                                                .shortName +
                                            "\t\t",
                                        style: textStyle)),
                                Expanded(
                                  child: Text(
                                      "(${teamIterator.current.win}-${teamIterator.current.loss})",
                                      style: textStyle),
                                  flex: 4,
                                )
                              ],
                            );
                          },
                        ),
                        margin: EdgeInsets.only(
                            left: 40.0, top: 10.0, right: 10.0)))
              ],
            ),
            color: Colors.white));
  }

  String _getNextLogoPath(Iterator<TeamStanding> iterator, List<Team> teams) {
    iterator.moveNext();
    Team team =
        teams.firstWhere((team) => iterator.current.teamId == team.teamId);
    return "assets/logos/${team.tricode.toUpperCase()}.png";
  }
}
