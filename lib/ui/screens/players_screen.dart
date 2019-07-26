import 'package:flutter/material.dart';
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
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            child: AnimatedSwitcher(
              child: _animatedWidgetContainer(),
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(child: child, opacity: animation);
              },
            ),
            color: Colors.white.withOpacity(0.55),
            padding: EdgeInsets.only(left: 10.0, right: 5.0),
          ),
          flex: 2,
        ),
        Expanded(
          child: Container(),
          flex: 12,
        )
      ],
    );
  }

  void _toggleAnimatedWidget() {
    this.setState(() {
      this._isSearch = !this._isSearch;
      this._animatedWidget = (_isSearch) ? _searchBar() : _teamSelector;
      this._buttonIconData = (_isSearch) ? Icons.cancel : Icons.search;
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
    return TextField(
      onChanged: (value) => _filterPlayers(value),
    );
  }

  void _filterPlayers(String value) {    
    //TODO Filter players in Bloc<PlayerLIst>
  }
}