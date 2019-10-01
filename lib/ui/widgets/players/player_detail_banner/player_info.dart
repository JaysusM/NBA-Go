import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nba_go/models/models.dart';

class PlayerInfo extends StatelessWidget {
  final Player player;
  final Team team;

  static const double HEADLINE_SIZE = 35.0;
  static const double SUBHEAD_SIZE = 25.0;
  static const double IMAGE_WIDTH = 190.0;
  static const double IMAGE_HEIGHT = 138.85;
  static const double IMAGE_MARGIN_RIGHT = 15.0;
  static const double IMAGE_MARGIN_LEFT = 15.0;
  static const double PLAYER_NAME_MARGIN_RIGHT = 10;
  static const double TEXT_SIZE_FACTOR = 0.75;

  final Widget vSeparator = Container(height: 7.5);

  PlayerInfo({@required this.player, @required this.team})
      : assert(player != null),
        assert(team != null);

  @override
  Widget build(BuildContext context) {
    String playerImageURL = NBALinks.getPlayerProfilePic(player.personId);
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle headlineStyle =
        textTheme.headline.copyWith(fontSize: HEADLINE_SIZE);
    TextStyle subheadStyle = textTheme.subhead.copyWith(fontSize: SUBHEAD_SIZE);
        return Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                      child: Opacity(
                          child: Image.asset(
                              'assets/logos/${this.team.tricode.toUpperCase()}.png'),
                          opacity: 0.3)),
                  Positioned(
                      child: Container(
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
                  bottom: 0.0
                  )
                ],
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    vSeparator,
                    SizedBox(
                      child: AutoSizeText(
                        player.firstName,
                        style: subheadStyle,
                      ),
                      width: MediaQuery.of(context).size.width -
                          (IMAGE_WIDTH +
                              IMAGE_MARGIN_RIGHT +
                              PLAYER_NAME_MARGIN_RIGHT),
                      height: subheadStyle.fontSize,
                    ),
                    SizedBox(
                      child: AutoSizeText(
                        player.lastName,
                        style: headlineStyle,
                      ),
                      width: MediaQuery.of(context).size.width -
                          (IMAGE_WIDTH +
                              IMAGE_MARGIN_RIGHT +
                              PLAYER_NAME_MARGIN_RIGHT +
                              IMAGE_MARGIN_LEFT),
                      height: headlineStyle.fontSize,
                    ),
                    vSeparator,
                    SizedBox(
                      child: AutoSizeText(
                      '${(player.jersey.isNotEmpty) ? '#' + player.jersey + '  |  ' : ''}${player.pos}  |  ${team.shortName}',
                      style: subheadStyle.apply(fontSizeFactor: TEXT_SIZE_FACTOR)
                ),
                width: MediaQuery.of(context).size.width -
                      (IMAGE_WIDTH +
                          IMAGE_MARGIN_RIGHT +
                          PLAYER_NAME_MARGIN_RIGHT +
                          IMAGE_MARGIN_LEFT),
                height: subheadStyle.fontSize*TEXT_SIZE_FACTOR
                ),
                vSeparator,
                Text(
                  player.dobAge + " years",
                  style: subheadStyle.apply(fontSizeFactor: TEXT_SIZE_FACTOR),
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
