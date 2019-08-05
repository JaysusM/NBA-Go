import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nba_go/models/models.dart';

class PlayerInfo extends StatelessWidget {
  final Player player;
  static const double HEADLINE_SIZE = 35.0;
  static const double SUBHEAD_SIZE = 25.0;
  static const double IMAGE_WIDTH = 190.0;
  static const double IMAGE_HEIGHT = 138.85;
  static const double IMAGE_MARGIN_RIGHT = 15.0;
  static const double IMAGE_MARGIN_LEFT = 15.0;
  static const double PLAYER_NAME_MARGIN_RIGHT = 10;

  final Widget vSeparator = Container(height: 7.5);

  PlayerInfo({@required this.player}) : assert(player != null);

  @override
  Widget build(BuildContext context) {
    String playerImageURL = NBALinks.getPlayerProfilePic(player.personId);
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle headlineStyle = textTheme.headline.copyWith(fontSize: HEADLINE_SIZE);
    TextStyle subheadStyle = textTheme.subhead.copyWith(fontSize: SUBHEAD_SIZE);

    return SizedBox(
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          child: FadeInImage.assetNetwork(
              fit: BoxFit.fitWidth,
              fadeOutCurve: Curves.linear,
              fadeOutDuration: Duration(milliseconds: 600),
              image: playerImageURL,
              placeholder: 'assets/player_placeholder.png'),
          width: IMAGE_WIDTH,
          height: IMAGE_HEIGHT,
          margin: EdgeInsets.only(right: IMAGE_MARGIN_RIGHT),
        ),
        Container(child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            vSeparator,
            SizedBox(
              child: AutoSizeText(
                player.firstName,
                style: subheadStyle,
              ),
              width: MediaQuery.of(context).size.width - 
                (IMAGE_WIDTH + IMAGE_MARGIN_RIGHT+PLAYER_NAME_MARGIN_RIGHT),
              height: subheadStyle.fontSize,
            ),
            SizedBox(
              child: AutoSizeText(
                player.lastName,
                style: headlineStyle,
              ),
              width: MediaQuery.of(context).size.width - 
                (IMAGE_WIDTH + IMAGE_MARGIN_RIGHT + PLAYER_NAME_MARGIN_RIGHT + IMAGE_MARGIN_LEFT),
              height: headlineStyle.fontSize,
            ),
            vSeparator,
            Text(
              '${(player.jersey.isNotEmpty) ? '#' + player.jersey + '  |  ' : ''}${player.pos}',
              style: subheadStyle.apply(fontSizeFactor: 0.75),
            ),
            vSeparator,
            Text(
              player.dobAge + " years",
              style: subheadStyle.apply(fontSizeFactor: 0.75),
            )
          ],
        ),
        margin: EdgeInsets.only(top: 50.0),
        )
      ],
      ),
      height: 190.0,
    );
  }
}
