import 'package:flutter/material.dart';
import 'package:nba_go/models/game_detail.dart';
import 'package:nba_go/ui/widgets/games/game_detail_card.dart';

class GameDetailScreen extends StatelessWidget {
  final GameDetail gameDetail;

  GameDetailScreen(this.gameDetail) : assert(gameDetail != null);

  @override
  Widget build(BuildContext context) {
    return GameDetailCard(gameDetail);
  }
}