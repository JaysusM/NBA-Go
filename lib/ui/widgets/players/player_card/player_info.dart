import 'package:flutter/material.dart';
import 'package:nba_go/models/models.dart';

class PlayerInfo extends StatelessWidget {
  final Player player;

  PlayerInfo({@required this.player}) : assert(player != null);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Color primaryColor = Theme.of(context).primaryColor;
    Color accentColor = Theme.of(context).accentColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(height: 6.0),
        Text(player.firstName,
            style: textTheme.subhead.copyWith(color: primaryColor)),
        Text(player.lastName,
            style: textTheme.headline.copyWith(color: primaryColor)),
        Text(
            '#${(player.jersey.isNotEmpty) ? player.jersey : '00'} | ${player.pos}',
            style: textTheme.subhead.copyWith(color: accentColor)),
        Text(
          "Age: ${player.dobAge}", style: textTheme.subhead.copyWith(color: accentColor)
        )
          
      ],
    );
  }
}
