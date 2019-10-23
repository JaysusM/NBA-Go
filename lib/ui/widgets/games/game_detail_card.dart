import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/models/game_detail.dart';
import 'package:nba_go/models/links.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/ui/widgets/utils/loading_widget.dart';

class GameDetailCard extends StatefulWidget {
  final String gameDate, gameId;

  GameDetailCard(this.gameDate, this.gameId)
      : assert(gameDate != null),
        assert(gameId != null);

  @override
  State<StatefulWidget> createState() => GameDetailCardState();
}

class GameDetailCardState extends State<GameDetailCard> {
  List<GamePlayerStats> _players;
  bool _homePlayersSelected;
  Timer _refreshTimer;
  GameDetail _gameDetail;
  static const _RELOAD_DATA_IN_SECONDS = 2;
  bool _refresh;

  @override
  void initState() {
    this._refresh = true;
    this._refreshTimer =
        Timer.periodic(Duration(seconds: _RELOAD_DATA_IN_SECONDS), (_) {
      this.setState(() {
        this._refresh = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    this._refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GameStatsBloc gameStatsBloc = BlocProvider.of<GameStatsBloc>(context);
    if (this._refresh) {
      this._refresh = false;
      gameStatsBloc.dispatch(
          FetchGameStats(gameDate: widget.gameDate, gameId: widget.gameId));
    }
    return BlocBuilder(
      bloc: gameStatsBloc,
      builder: (BuildContext context, GameStatsState state) {
        if (state is GameStatsLoaded) {
          this._gameDetail = state.gameStats;
          if(this._gameDetail.status+1 == GameStatus.FINISHED.index) {
            this._refreshTimer.cancel();
          }
          return _gameStatsContent();
        } else if (state is GameStatsEmpty || state is GameStatsError) {
          return ErrorWidget("ERROR. Couldn't get game stats data");
        } else if (state is GameStatsLoading) {
          return (this._gameDetail?.gameId == widget.gameId)
              ? this._gameStatsContent()
              : LoadingWidget();
        }
        return ErrorWidget("ERROR. Unknown game stats state");
      },
    );
  }

  Widget _gameStatsContent() {
    this._players =
        (this._players == null) ? this._gameDetail.awayPlayers : this._players;
    this._homePlayersSelected =
        (this._homePlayersSelected == null) ? false : this._homePlayersSelected;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:
              Text("${_gameDetail.awayTricode} @ ${_gameDetail.homeTricode}"),
        ),
        body: Column(children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buttonSetTeamPlayers(
                  _gameDetail.awayTricode,
                  _gameDetail.awayScore,
                  _gameDetail.awayPlayers,
                  false,
                  !this._homePlayersSelected),
              _buttonSetTeamPlayers(
                  _gameDetail.homeTricode,
                  _gameDetail.homeScore,
                  _gameDetail.homePlayers,
                  true,
                  this._homePlayersSelected)
            ],
          ),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 0.5,
                              color: Theme.of(context).primaryColor))),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Row(children: <Widget>[
                        Container(
                          child: DataTable(
                            horizontalMargin: 10.0,
                            rows: this
                                ._players
                                .map((player) => DataRow(cells: <DataCell>[
                                      _getPlayerNameCell(player)
                                    ]))
                                .toList(),
                            columns: <DataColumn>[_getPlayerColumn()],
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 0.5,
                                      color: Theme.of(context).primaryColor))),
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                    columnSpacing: 10.0,
                                    horizontalMargin: 15.0,
                                    rows: this
                                        ._players
                                        .map((player) => DataRow(
                                            cells: _getDataCells(player)))
                                        .toList(),
                                    columns: _getDataColumns())))
                      ]))))
        ]));
  }

  Widget _buttonSetTeamPlayers(
      String tricode, String score, List<GamePlayerStats> players, bool isHome,
      [bool selected = false]) {
    TextStyle textStyle = Theme.of(context).textTheme.body1;
    textStyle = (selected)
        ? textStyle.copyWith(fontWeight: FontWeight.bold)
        : textStyle;

    return InkWell(
      child: Row(
        children: <Widget>[
          Image.asset(
            "assets/logos/${tricode.toUpperCase()}.png",
            width: 20.0,
            height: 20.0,
          ),
          Container(
            child: Text(tricode, style: textStyle),
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 10.0, 15.0),
          ),
          Container(
            child: Text(score, style: textStyle),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          )
        ],
      ),
      onTap: () {
        this.setState(() {
          this._players = players;
          this._homePlayersSelected = isHome;
        });
      },
    );
  }

  List<DataCell> _getDataCells(GamePlayerStats player) {
    return <DataCell>[
      DataCell(Text(player.pos)),
      DataCell(Text(player.min)),
      DataCell(Text(player.pts)),
      DataCell(Text(player.totReb)),
      DataCell(Text(player.ast)),
      DataCell(Text(player.stl)),
      DataCell(Text(player.blk)),
      DataCell(Text(player.fgm)),
      DataCell(Text(player.fga)),
      DataCell(Text(player.fgp)),
      DataCell(Text(player.tpm)),
      DataCell(Text(player.tpa)),
      DataCell(Text(player.tpp)),
      DataCell(Text(player.ftm)),
      DataCell(Text(player.fta)),
      DataCell(Text(player.ftp)),
      DataCell(Text(player.offReb)),
      DataCell(Text(player.defReb)),
      DataCell(Text(player.to)),
      DataCell(Text(player.plusMinus)),
      DataCell(Text(player.pf))
    ];
  }

  List<DataColumn> _getDataColumns() {
    return <DataColumn>[
      DataColumn(label: const Text('POS')),
      DataColumn(label: const Text('MIN')),
      DataColumn(label: const Text('PTS')),
      DataColumn(label: const Text('REB')),
      DataColumn(label: const Text('AST')),
      DataColumn(label: const Text('STL')),
      DataColumn(label: const Text('BLK')),
      DataColumn(label: const Text('FGM')),
      DataColumn(label: const Text('FGA')),
      DataColumn(label: const Text('FG%')),
      DataColumn(label: const Text('3PM')),
      DataColumn(label: const Text('3PA')),
      DataColumn(label: const Text('3P%')),
      DataColumn(label: const Text('FTM')),
      DataColumn(label: const Text('FTA')),
      DataColumn(label: const Text('FT%')),
      DataColumn(label: const Text('OREB')),
      DataColumn(label: const Text('DREB')),
      DataColumn(label: const Text('TO')),
      DataColumn(label: const Text('+/-')),
      DataColumn(label: const Text('PF')),
    ];
  }

  DataCell _getPlayerNameCell(GamePlayerStats player) {
    return DataCell(Container(
        child: Row(children: <Widget>[
          (player.isOnCourt)
              ? Container(
                  width: 4.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.red),
                )
              : Container(),
          Container(width: 5.0),
          CircleAvatar(
              backgroundColor: Colors.white,
              child: FadeInImage.assetNetwork(
                placeholder: "assets/players_placeholder.png",
                image: NBALinks.getPlayerProfilePic(player.personId),
              )),
          Container(width: 10.0),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text(player.firstName), Text(player.lastName)])
        ]),
        margin: EdgeInsets.only(right: 10.0)));
  }

  DataColumn _getPlayerColumn() {
    return DataColumn(label: const Text('PLAYER'));
  }
}
