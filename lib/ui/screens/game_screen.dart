import 'package:flutter/material.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/ui/widgets/widgets.dart';

class GameScreen extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NBALinks.nbaLinks,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          DateTime currentDate = snapshot.data.currentDate;
          return _GameScreenView(currentDate: currentDate);
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error loading calendar data', style: TextStyle(color: Colors.red));
        } else
          return Container();
      }
    );
  }
}

class _GameScreenView extends StatelessWidget {

  final DateTime currentDate;

  _GameScreenView({@required this.currentDate}):
    assert(currentDate != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor.withOpacity(1.0),
        appBar: AppBar(title: Text('NBA Go!')),
        body: NestedScrollView(
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
        ) 
    );
  }
}