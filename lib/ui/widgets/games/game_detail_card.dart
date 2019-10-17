import 'package:flutter/material.dart';
import 'package:nba_go/models/game_detail.dart';

class GameDetailCard extends StatelessWidget {

  final GameDetail gameDetail;

  GameDetailCard(this.gameDetail)
    : assert(gameDetail != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${gameDetail.awayTricode} @ ${gameDetail.homeTricode}"),
      ),
    );
  }
}