import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nba_go/blocs/player_list_bloc.dart';
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
  PlayerListBloc _playerListBloc;

  @override
  void initState() { 
    super.initState();
    this._isSearch = true;
    this._toggleAnimatedWidget();
  }

  @override
  Widget build(BuildContext context) {
    this._playerListBloc = BlocProvider.of<PlayerListBloc>(context);
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
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.only(left: 10.0, right: 5.0),
              margin: EdgeInsets.all(5.0),
            ),
            expandedHeight: 70.0
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
            icon: Icon(this._buttonIconData, color: Colors.white), 
            onPressed: () => this._toggleAnimatedWidget()
          ),
          flex: 1
        )
      ]
    );
  }
  
  Widget _searchBar() {
    return Container(
      child: TextField(
        onChanged: (value) => _filterPlayers(value),
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
          ),
        ),
      ),
      margin: EdgeInsets.all(15.0),
    );
  }

  void _filterPlayers(String value) {    
    this._playerListBloc.dispatch(FilterPlayerListByValue(value.toLowerCase()));
    this.setState(() {});
  }
}