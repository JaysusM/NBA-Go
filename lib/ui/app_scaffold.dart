import 'package:nba_go/models/links.dart';
import 'package:nba_go/ui/screens/screens.dart';

import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:line_icons/line_icons.dart';

class AppScaffold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppScaffoldState();
}

class AppScaffoldState extends State<AppScaffold> {

  int _currentIndex;
  PageController _pageController;

  @override
  void initState() { 
    this._currentIndex = 0;
    this._pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    this._pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NBALinks.nbaLinks,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          DateTime currentDate = snapshot.data.currentDate;
          int stage = snapshot.data.stage;
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'NBA Go', 
                style: Theme.of(context).textTheme.title
              )
            ),
            body: PageView (
              onPageChanged: (index) {
                this.setState(() {
                  this._currentIndex = index;
                });
              },
              controller: this._pageController,
              children: <Widget>[
                GameScreen(currentDate: currentDate),
                StandingsScreen(stage: stage),
                PlayersScreen()
              ],
            ),
            bottomNavigationBar: BottomNavyBar(              
              iconSize: 24.0,
              backgroundColor: Theme.of(context).primaryColor,
              showElevation: true,
              selectedIndex: _currentIndex,
              onItemSelected: (index) => this.setState(() {
                this._currentIndex = index;
                this._pageController.animateToPage(
                  index,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 700));
              }),
              items: <BottomNavyBarItem>[
                BottomNavyBarItem(
                  activeColor: Theme.of(context).toggleableActiveColor,
                  inactiveColor: Theme.of(context).accentColor,
                  icon: Icon(LineIcons.calendar),
                  title: Text('Calendar')
                ),
                BottomNavyBarItem(
                  activeColor: Theme.of(context).toggleableActiveColor,
                  inactiveColor: Theme.of(context).accentColor,
                  icon: Icon(LineIcons.trophy),
                  title: Text('Standings'),
                ),
                BottomNavyBarItem(
                  activeColor: Theme.of(context).toggleableActiveColor,
                  inactiveColor: Theme.of(context).accentColor,
                  icon: Icon(LineIcons.group),
                  title: Text('Players'),
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error loading calendar data', style: TextStyle(color: Colors.red));
        } else
          return Image.asset('assets/splash.png', fit: BoxFit.fill);
      }
    );
  }
}