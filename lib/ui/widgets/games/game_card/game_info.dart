import 'package:flutter/material.dart';
import 'package:nba_go/models/models.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
      case GameStatus.NOT_STARTED:
        infoContent = <Widget>[
          Text(startTimeString, style: Theme.of(context).textTheme.body1),
          separator,
          Text("-")
        ];
        break;
      case GameStatus.PLAYING:
        infoContent = <Widget>[
          liveWidget(context),         
          separator, 
          AutoSizeText(
            "${period.toString().split('.').last} - $clock",
            style: Theme.of(context).textTheme.caption,
            maxLines: 1,
          )
        ];
        break;
      case GameStatus.FINISHED:
        infoContent = <Widget>[
          Text(startTimeString, style: Theme.of(context).textTheme.body1),
          separator,
          AutoSizeText(
            (period.index < Period.OT1.index) ? "FT" : "FT - ${period.toString().split(".").last}",
            maxLines: 1,
          )
        ];
        break;
    }

    return Column(
        children: infoContent
    );
  }

  Widget liveWidget(BuildContext context) {
    return Container(
      child: Text('LIVE', style: Theme.of(context).textTheme.caption),
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