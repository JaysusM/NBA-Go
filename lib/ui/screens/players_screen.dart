import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nba_go/ui/widgets/widgets.dart';

class PlayersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlayersScreenState();
}

class PlayersScreenState extends State<PlayersScreen> {

  bool _isSearch;
  final Widget _teamSelector = TeamSelector();

  Widget _animatedWidget;
  IconData _buttonIconData;
  int _animatedKeyValue;

  @override
  void initState() { 
    super.initState();
    this._isSearch = true;
    this._toggleAnimatedWidget();
  }

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
              child: AnimatedSwitcher(
                child: _animatedWidgetContainer(),
                duration: Duration(milliseconds: 760),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.ease,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SizeTransition(child: child, sizeFactor: animation);
                },
              ),
              color: Colors.white.withOpacity(0.55),
              padding: EdgeInsets.only(left: 10.0, right: 5.0),
              margin: EdgeInsets.only(bottom: 12.0)
            ),
            expandedHeight: 80.0
          ),
        ];
      }, body: PlayerList(),
    );
  }

  void _toggleAnimatedWidget() {
    this.setState(() {
      this._isSearch = !this._isSearch;
      this._animatedWidget = (_isSearch) ? _searchBar() : _teamSelector;
      this._buttonIconData = (_isSearch) ? LineIcons.reply : Icons.search;
      this._animatedKeyValue = (_isSearch) ? 1 : 2;
    });
  }

  Widget _animatedWidgetContainer() {
    return Row(
      key: ValueKey(this._animatedKeyValue),
      children: <Widget> [
        Expanded(
          child: _animatedWidget,
          flex: 9,
        ),
        Expanded(
          child: IconButton(
            icon: Icon(this._buttonIconData, color: Theme.of(context).primaryColor), 
            onPressed: () => this._toggleAnimatedWidget()
          ),
          flex: 1,
        )
      ]
    );
  }
  
  Widget _searchBar() {
    return Container(
      child: TextField(
        onChanged: (value) => _filterPlayers(value),
      ),
      margin: EdgeInsets.all(15.0),
    );
  }

  void _filterPlayers(String value) {    
    //TODO Filter players in Bloc<PlayerLIst>
  }
}