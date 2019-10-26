import 'package:flutter/material.dart';
import 'package:nba_go/models/models.dart';

class TopThreeTeamsStandings extends StatelessWidget {
  final Iterator<TeamStanding> teamIterator;
  final List<Team> teamList;

  TopThreeTeamsStandings({@required this.teamIterator, @required this.teamList})
    : assert(teamIterator != null),
      assert(teamList != null);

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _topThreeTeamsView(context));
  }

  List<Widget> _topThreeTeamsView(BuildContext context) {
    List<Widget> widgetList = List<Widget>();
    int startFlexSize = 15;
    for (int i = 1; i <= 3; i++) {
      widgetList.add(
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
            Image.asset(_getNextLogoPath(teamIterator, teamList),
                height: 100.0),
            Container(height: 5.0),
            Text("$i",
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontSize: 30.0 - i*2)),
            Text("(${teamIterator.current.win}-${teamIterator.current.loss})",
                style: Theme.of(context).textTheme.body2)
          ]),
          flex: startFlexSize - (i),
        ),
      );
    }
    return widgetList;
  }

  String _getNextLogoPath(Iterator<TeamStanding> iterator, List<Team> teams) {
    iterator.moveNext();
    Team team =
        teams.firstWhere((team) => iterator.current.teamId == team.teamId);
    return "assets/logos/${team.tricode.toUpperCase()}.png";
  }
}
