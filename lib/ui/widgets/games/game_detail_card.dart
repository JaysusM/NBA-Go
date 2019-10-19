import 'package:flutter/material.dart';
import 'package:nba_go/models/game_detail.dart';
import 'package:nba_go/models/links.dart';

class GameDetailCard extends StatefulWidget {
  final GameDetail gameDetail;

  GameDetailCard(this.gameDetail) : assert(gameDetail != null);

  @override
  State<StatefulWidget> createState() => GameDetailCardState();
}

class GameDetailCardState extends State<GameDetailCard> {
  List<GamePlayerStats> players;
  bool homePlayersSelected;

  @override
  void initState() {
    this.players = widget.gameDetail.awayPlayers;
    this.homePlayersSelected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              "${widget.gameDetail.awayTricode} @ ${widget.gameDetail.homeTricode}"),
        ),
        body: Column(children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buttonSetTeamPlayers(
                  widget.gameDetail.awayTricode,
                  widget.gameDetail.awayScore,
                  widget.gameDetail.awayPlayers,
                  false,
                  !this.homePlayersSelected),
              _buttonSetTeamPlayers(widget.gameDetail.homeTricode,
                  widget.gameDetail.homeScore,
                  widget.gameDetail.homePlayers, true, this.homePlayersSelected)
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
                                .players
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
                                        .players
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
          this.players = players;
          this.homePlayersSelected = isHome;
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
      DataCell(Text(player.ftm)),
      DataCell(Text(player.fta)),
      DataCell(Text(player.ftp)),
      DataCell(Text(player.tpm)),
      DataCell(Text(player.tpa)),
      DataCell(Text(player.tpp)),
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
      DataColumn(label: const Text('FTM')),
      DataColumn(label: const Text('FTA')),
      DataColumn(label: const Text('FT%')),
      DataColumn(label: const Text('3PM')),
      DataColumn(label: const Text('3PA')),
      DataColumn(label: const Text('3P%')),
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
