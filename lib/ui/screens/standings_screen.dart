import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/blocs/standings_bloc.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/ui/widgets/widgets.dart';

class StandingsScreen extends StatelessWidget {

  int stage;

  StandingsScreen({@required this.stage});

  @override
  Widget build(BuildContext context) {
    StandingListBloc standingListBloc =
        BlocProvider.of<StandingListBloc>(context);

    standingListBloc.dispatch(FetchStandingList());

    return BlocBuilder(
      bloc: standingListBloc,
      builder: (BuildContext context, StandingListState state) {
        if (state is StandingListEmpty) {
          standingListBloc.dispatch(FetchStandingList());
          return LoadingWidget();
        } else if (state is StandingListLoading) {
          List<TeamStanding> standings = standingListBloc.standings;
          List<PlayoffsSeries> series = standingListBloc.playoffsSeries;
          if (standings == null || series == null) {
            return LoadingWidget();
          } else {
            bool isLoadingParam = true;
            return StandingsScreenView(standings, series, stage, isLoadingParam);
          }
        } else if (state is StandingListLoaded)
          return StandingsScreenView(state.standings, state.playoffsSeries, stage);
        else if (state is StandingListError)
          return ErrorMessageWidget(error: state.error);
        return ErrorMessageWidget(error: 'Unknown state $state');
      },
    );
  }
}

class StandingsScreenView extends StatefulWidget {
  final List<TeamStanding> standings;
  final List<PlayoffsSeries> playoffsSeries;
  final bool isLoading;
  final int stage;

  StandingsScreenView(this.standings, this.playoffsSeries, this.stage,
      [this.isLoading = false]);

  @override
  State<StatefulWidget> createState() => StandingsScreenViewState();
}

class StandingsScreenViewState extends State<StandingsScreenView> {
  Conference selectedConference;
  static const TEAMS_PER_CONFERENCE = 15;

  @override
  void initState() {
    super.initState();
    if (widget.playoffsSeries.length != 0)
      this.selectedConference = Conference.PLAYOFFS;
    else
      this.selectedConference = Conference.EAST;
  }

  @override
  Widget build(BuildContext context) {
    TeamListBloc teamListBloc = BlocProvider.of<TeamListBloc>(context);
    List<Team> teamList = (teamListBloc.currentState as TeamListLoaded).teams;
    List<TeamStanding> selectedConferenceTeams =
        (this.selectedConference != Conference.PLAYOFFS)
            ? widget.standings
                .where((teamStanding) =>
                    teamStanding.conference == this.selectedConference)
                .toList()
            : widget.standings;
    Set<TeamStanding> orderedTeams = Set();

    for (int i = 1; i <= TEAMS_PER_CONFERENCE; i++) {
      orderedTeams.add(selectedConferenceTeams
          .firstWhere((teamStanding) => teamStanding.confRank == i));
    }

    Iterator<TeamStanding> teamIterator = orderedTeams.iterator;

    return Stack(children: <Widget>[
      AnimatedSwitcher(
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
                          conferenceSelector(
                              "assets/logos/WEST.png", Conference.WEST),
                          (widget.stage == 3) ? conferenceSelector(
                              "assets/logos/nba.gif", Conference.PLAYOFFS) : Container(),
                          conferenceSelector(
                              "assets/logos/EAST.png", Conference.EAST)
                        ],
                      ),
                      color: Theme.of(context).backgroundColor,
                      height: 70.0,
                      padding: EdgeInsets.symmetric(vertical: 10.0)),
                ]..addAll((this.selectedConference != Conference.PLAYOFFS)
                    ? standingsListWidget(teamIterator, teamList)
                    : [Bracket(playoffsSeries: widget.playoffsSeries, teams: teamList)]),
              ),
              color: Colors.white)),
      (widget.isLoading) ? LoadingWidget() : Container()
    ]);
  }

  String _getNextLogoPath(Iterator<TeamStanding> iterator, List<Team> teams) {
    iterator.moveNext();
    Team team =
        teams.firstWhere((team) => iterator.current.teamId == team.teamId);
    return "assets/logos/${team.tricode.toUpperCase()}.png";
  }

  List<Widget> standingsListWidget(
      Iterator<TeamStanding> teamIterator, List<Team> teamList) {
    return [
      Container(
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(70, 80),
            )),
        height: 200.0,
        padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
        child: TopThreeTeamsStandings(
            teamIterator: teamIterator, teamList: teamList),
      ),
      Expanded(
          child: Container(
              color: Colors.white,
              child: this.standingsList(teamIterator, teamList),
              margin: EdgeInsets.only(left: 40.0, top: 10.0, right: 10.0)))
    ];
  }

  Widget conferenceSelector(String conferenceLogo, Conference conference) {
    return InkWell(
      child: SizedBox(
          child: Opacity(
              child: Image.asset('$conferenceLogo', height: 60.0),
              opacity: (selectedConference == conference) ? 1.0 : 0.3),
          height: 40.0,
          width: 40.0),
      onTap: () => this.setState(() {
        this.selectedConference = conference;
      }),
    );
  }

  Widget standingsList(
      Iterator<TeamStanding> teamIterator, List<Team> teamList) {
    return ListView.builder(
      // -3 Because we showed the three top teams before
      itemCount: TEAMS_PER_CONFERENCE - 3,
      itemBuilder: (BuildContext context, int index) {
        int rank = index + 4;
        TextStyle textStyle = Theme.of(context).textTheme.body1.copyWith(
            fontSize: 22.0,
            fontFamily: 'Roboto',
            fontWeight: (rank <= 8) ? FontWeight.w300 : FontWeight.w200,
            color: Theme.of(context).primaryColor);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text("$rank",
                  style: textStyle.copyWith(fontWeight: FontWeight.w600)),
              flex: 2,
            ),
            Expanded(
              child: Image.asset(_getNextLogoPath(teamIterator, teamList),
                  width: textStyle.fontSize, height: textStyle.fontSize),
              flex: 1,
            ),
            Expanded(flex: 2, child: Container()),
            Expanded(
                flex: 7,
                child: Text(
                    teamList
                            .firstWhere((team) =>
                                teamIterator.current.teamId == team.teamId)
                            .shortName +
                        "\t\t",
                    overflow: TextOverflow.ellipsis,
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
    );
  }
}
