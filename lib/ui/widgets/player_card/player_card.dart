import 'package:flutter/material.dart';
import 'package:nba_go/models/models.dart';

class PlayerCard extends StatelessWidget {

  final Player player;

  PlayerCard({@required this.player})
    : assert(player != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text("${player.lastName}, ${player.firstName}")
    );
  }
}