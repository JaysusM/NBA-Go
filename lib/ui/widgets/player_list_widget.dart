import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/player_list_bloc.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/ui/widgets/widgets.dart';
import 'dart:math';

class PlayerList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    PlayerListBloc playerListBloc = BlocProvider.of<PlayerListBloc>(context);
    return BlocBuilder(
      bloc: playerListBloc,
      builder: (BuildContext context, PlayerListState state) {
        if (state is PlayerListEmpty) {
          playerListBloc.dispatch(FetchPlayerList());
          return LoadingWidget();
        } else if (state is PlayerListLoading)
          return LoadingWidget();
        else if (state is PlayerListError) {
          print(state.error);
          return ErrorMessageWidget(error: 'Error loading player list');
        } else if (state is PlayerListLoaded) {
          return PlayerListView(players: state.players);
        } else
          return ErrorMessageWidget(error: 'Error. Unknown state for PlayerList $state');
      },
    );
  }
}

class PlayerListView extends StatefulWidget {

  final List<Player> players;

  PlayerListView({@required this.players})
    : assert(players != null);

  _PlayerListViewState createState() => _PlayerListViewState();
}

class _PlayerListViewState extends State<PlayerListView> {
  
  ScrollController _scrollController;
  int _quantityPlayersShown;
  static const int NUMBER_OF_CARD_TO_LOAD = 20;
  bool _showTopButton;

  @override
  void initState() {
    this._showTopButton = false;
    this._scrollController = ScrollController();
    this._quantityPlayersShown = NUMBER_OF_CARD_TO_LOAD;

    this._scrollController.addListener(() {
      if(this._scrollController.position.pixels > 0.0)
        this.setState(() {this._showTopButton = true;});
      else
        this.setState(() {this._showTopButton = false;});

      // The -50.0 pixels are for preloading data before reaching the end
      // avoiding unnecessary wait for loading time
      if(this._scrollController.position.pixels >= this._scrollController.position.maxScrollExtent - 50.0)
        this.loadMorePlayers();
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.builder(
          controller: this._scrollController,
          itemCount: min(this._quantityPlayersShown, widget.players.length),
          itemBuilder: (BuildContext context, int index) {
            return PlayerCard(player: widget.players[index]);
          },
        ),
        Positioned(
          child: AnimatedSwitcher(
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.ease,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(child: child, sizeFactor: animation);
            },
            child: (this._showTopButton)
            ? Container(
              child: FloatingActionButton(
                key: ValueKey(1),
                backgroundColor: Theme.of(context).accentColor,
                foregroundColor: Theme.of(context).primaryColor,
                child: Icon(
                    Icons.arrow_upward
                ), 
                onPressed: () {
                  this._scrollController.animateTo(
                    0.0, 
                    curve: Curves.bounceInOut, 
                    duration: Duration(milliseconds: 500)
                  );
                },
              ),
              margin: EdgeInsets.all(5.0),
            ) : Container(key: ValueKey(2)),
            duration: Duration(milliseconds: 500)
          ),
          bottom: 20.0,
          right: 20.0,
        )
      ]
    );
  }

  void loadMorePlayers() {
    this.setState(() {
      this._quantityPlayersShown += NUMBER_OF_CARD_TO_LOAD;
    });
  }
}