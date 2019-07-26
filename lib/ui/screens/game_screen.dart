import 'package:flutter/material.dart';
import 'package:nba_go/ui/widgets/widgets.dart';

class GameScreen extends StatelessWidget {

  final DateTime currentDate;

  GameScreen({@required this.currentDate}):
    assert(currentDate != null);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              child: DateSelector(this.currentDate),
              margin: EdgeInsets.only(bottom: 12.0)
              ),
            expandedHeight: 80.0,
          ),
        ];
      }, body: GameListView(),
    );
  }
}