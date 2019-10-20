import 'package:flutter/material.dart';
import 'package:nba_go/ui/widgets/games/game_detail_card.dart';

class GameDetailScreen extends StatelessWidget {
  final String gameDate, gameId;

  GameDetailScreen(this.gameDate, this.gameId)
      : assert(gameDate != null),
        assert(gameId != null);

  @override
  Widget build(BuildContext context) {
    return GameDetailCard(gameDate, gameId);
  }
}
