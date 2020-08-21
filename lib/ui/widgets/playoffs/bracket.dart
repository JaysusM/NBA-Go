import 'package:flutter/material.dart';
import 'package:nba_go/models/models.dart';
const double BRACKET_WIDTH = 275.0;

class Bracket extends StatelessWidget {
  final List<PlayoffsSeries> playoffsSeries;
  final List<Team> teams;

  Bracket({@required this.playoffsSeries, @required this.teams})
      : assert(playoffsSeries != null),
        assert(teams != null);

  Widget stageBanner(String stage, BuildContext context) {
    return Container(
        child: Center(
            child: Text(stage,
                style: Theme.of(context)
                    .textTheme
                    .body1)),
        color: Theme.of(context).accentColor,
        width: BRACKET_WIDTH,
        height: 25);
  }

  Widget firstRoundBrackets(BuildContext context) {
    List<PlayoffsSeries> firstRounds = [];
    playoffsSeries.forEach((serie) {
      if (serie.roundNum == '1') firstRounds.add(serie);
    });

    return Column(
        children: [stageBanner("First Round", context)]..addAll(firstRounds
            .map((serie) => _SingleBracket(playoffsSeries: serie, teams: teams))
            .toList()));
  }

  Widget secondRoundBrackets(BuildContext context) {
    List<PlayoffsSeries> secondRounds = [];
    playoffsSeries.forEach((serie) {
      if (serie.roundNum == '2') secondRounds.add(serie);
    });

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [stageBanner("Second Round", context)]..addAll(secondRounds
            .map((serie) => _SingleBracket(playoffsSeries: serie, teams: teams))
            .toList()));
  }

  Widget conferenceFinals(BuildContext context) {
    List<PlayoffsSeries> secondRounds = [];
    playoffsSeries.forEach((serie) {
      if (serie.roundNum == '3') secondRounds.add(serie);
    });

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [stageBanner("Conference Finals", context)]..addAll(secondRounds
            .map((serie) => _SingleBracket(playoffsSeries: serie, teams: teams))
            .toList()));
  }

  Widget nbaFinals(BuildContext context) {
    List<PlayoffsSeries> secondRounds = [];
    playoffsSeries.forEach((serie) {
      if (serie.roundNum == '4') secondRounds.add(serie);
    });

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [stageBanner("NBA Finals", context)]..addAll(secondRounds
            .map((serie) => _SingleBracket(playoffsSeries: serie, teams: teams))
            .toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  firstRoundBrackets(context),
                  secondRoundBrackets(context),
                  conferenceFinals(context),
                  nbaFinals(context)
                ],
              ))),
      color: Theme.of(context).primaryColor,
    ));
  }
}

class _SingleBracket extends StatelessWidget {
  final PlayoffsSeries playoffsSeries;
  final List<Team> teams;

  _SingleBracket({@required this.playoffsSeries, @required this.teams})
      : assert(playoffsSeries != null),
        assert(teams != null);

  @override
  Widget build(BuildContext context) {
    Team topTeam = teams.firstWhere(
        (team) => team.teamId == playoffsSeries.topTeam.teamId, orElse: () {
      return Team.fromJSON(new Map());
    });
    Team bottomTeam = teams.firstWhere(
        (team) => team.teamId == playoffsSeries.bottomTeam.teamId, orElse: () {
      return Team.fromJSON(new Map());
    });

    return Container(
      child: Column(
        children: <Widget>[
          _PlayoffTeamRow(
              team: topTeam,
              teamRow: playoffsSeries.topTeam,
              isGameLive: playoffsSeries.isGameLive),
          Divider(height: 1.5, color: Theme.of(context).backgroundColor),
          _PlayoffTeamRow(
              team: bottomTeam,
              teamRow: playoffsSeries.bottomTeam,
              isGameLive: playoffsSeries.isGameLive),
        ],
      ),
      width: BRACKET_WIDTH,
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.symmetric(vertical: 2.5),
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.5),
    );
  }
}

class _PlayoffTeamRow extends StatelessWidget {
  final Team team;
  final PlayoffTeamRow teamRow;
  final bool isGameLive;

  _PlayoffTeamRow(
      {@required this.team, @required this.teamRow, @required this.isGameLive})
      : assert(team != null),
        assert(teamRow != null);

  Widget PlayoffTeamRowData(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.body1;
    double logoWidth = textStyle.fontSize + 5;

    if (this.isGameLive) textStyle = textStyle.copyWith(color: Colors.red);

    if (this.teamRow.isSeriesWinner)
      textStyle = textStyle.copyWith(fontWeight: FontWeight.w500);

    String imageAsset =
        "assets/logos/${(team.tricode == null) ? 'nba.gif' : (team.tricode.toUpperCase() + '.png')}";
    if (team.tricode == null) logoWidth += 5.5;
    String teamFullname = team.fullName == null ? "TBD" : team.fullName;
    String teamSeed = teamRow.seedNum.length == 0 ? "" : "(${teamRow.seedNum})";
    String teamWins = teamRow.wins.length == 0 ? "-" : teamRow.wins.toString();

    return Stack(alignment: Alignment.center, children: <Widget>[
      Align(
          child: Row(
            children: <Widget>[
              Image.asset(imageAsset, width: logoWidth),
              Container(width: 7.0),
              Text(teamFullname, style: textStyle),
              Container(width: 5.0),
              Text(
                teamSeed,
                style: textStyle.apply(fontSizeFactor: 0.7),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          alignment: Alignment.centerLeft),
      Align(
          child: Text(teamWins, style: textStyle),
          alignment: Alignment.centerRight)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5.0), child: PlayoffTeamRowData(context));
  }
}
