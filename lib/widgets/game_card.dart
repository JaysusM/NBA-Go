import 'package:auto_size_text/auto_size_text.dart';
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
      child: Row(
        children: <Widget> [
          Expanded(
            child: GameInfo(gameStatus: game.status, clock: game.clock, period: game.period, startTime: game.startTime),
            flex: 2,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                TeamRow(team: game.vTeam),
                Divider(height: 1.5, color: Theme.of(context).backgroundColor),
                TeamRow(team: game.hTeam)
              ],
            ), 
            flex: 8,
          )
        ]
      ),
      decoration: BoxDecoration(
        color: Colors.white
      ),
      margin: EdgeInsets.only(bottom: 2.5),
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.5),
    );
  }
}

class GameInfo extends StatelessWidget {

  final GameStatus gameStatus;
  final Period period;
  final String clock;
  final DateTime startTime;

  GameInfo({@required this.gameStatus, @required this.clock, @required this.period, @required this.startTime})
    : assert(gameStatus != null),
      assert(clock != null),
      assert(period != null),
      assert(startTime != null);

  @override
  Widget build(BuildContext context) {
    String startTimeString = _parseTimeToAMPMFormat(this.startTime.hour, this.startTime.minute);
    Widget separator = Container(height: 5.0);

    List<Widget> infoContent;
    switch (this.gameStatus) {
      case GameStatus.NOTSTARTED:
        infoContent = <Widget>[
          Text(startTimeString),
          separator,
          Text("-")
        ];
        break;
      case GameStatus.PLAYING:
        infoContent = <Widget>[
          liveWidget(context),         
          separator, 
          SizedBox(
            child: AutoSizeText(
            "${period.toString().split('.').last} - $clock",
            style: Theme.of(context).textTheme.body2,
            maxLines: 1,
            )
          )
        ];
        break;
      case GameStatus.FINISHED:
        infoContent = <Widget>[
          Text(startTimeString),
          separator,
          Text((period.index < Period.OT1.index) ? "FT" : period.toString().split(".").last)
        ];
        break;
    }

    return Column(
        children: infoContent
    );
  }

  Widget liveWidget(BuildContext context) {
    return Container(
      child: Text('LIVE', style: Theme.of(context).textTheme.body2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.red,
          width: 1.0
        )
      ),
      padding: EdgeInsets.symmetric(horizontal: 2.5, vertical: 1.5)
    );
  }

  String _numberToTwoDigitsString(int number) {
    return (number.toString().length == 1)
      ? "0$number"
      : "$number";
  }

  String _parseTimeToAMPMFormat(int hour, int minutes) {
    String minutesTwoDigits = _numberToTwoDigitsString(minutes);
    
    if(hour >= 12)
      return "${_numberToTwoDigitsString(hour-12)}:$minutesTwoDigits PM";
    else if(hour == 0)
      return "12:$minutesTwoDigits AM";
    else
      return "${_numberToTwoDigitsString(hour)}:$minutesTwoDigits AM";
  }
}

class TeamRow extends StatelessWidget {
  final GameTeam team;

  TeamRow({@required this.team})
    : assert(team != null);

  @override
  Widget build(BuildContext context) {

    TeamListBloc teamListBloc = BlocProvider.of<TeamListBloc>(context);
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
                    style: Theme.of(context).textTheme.body1
                  ),
                  alignment: Alignment.centerLeft
                ),
                Align(
                  child: Text(
                    team.score.toString(),
                    style: Theme.of(context).textTheme.body1
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
      },
    );
  }
}