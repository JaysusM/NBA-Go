import 'package:flutter/material.dart';
import 'package:nba_go/models/game_detail.dart';
import 'package:data_tables/data_tables.dart';
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
  int sortedIndex;

  @override
  void initState() {
    this.players = widget.gameDetail.homePlayers;
    this.homePlayersSelected = true;
    this.sortedIndex = null;
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
      body: NativeDataTable.builder(
          alwaysShowDataTable: true,
          sortAscending: true,
          rowsPerPage: this.players.length,
          itemCount: this.players.length,
          sortColumnIndex: this.sortedIndex,
          itemBuilder: (int index) {
            return DataRow.byIndex(
                index: index, cells: _getDataCells(index));
          },
          header: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buttonSetTeamPlayers(
                  widget.gameDetail.awayTricode,
                  widget.gameDetail.awayPlayers,
                  false,
                  !this.homePlayersSelected),
              _buttonSetTeamPlayers(widget.gameDetail.homeTricode,
                  widget.gameDetail.homePlayers, true, this.homePlayersSelected)
            ],
          ),
          actions: <Widget>[],
          columns: _getDataColumns()),
    );
  }

  Widget _buttonSetTeamPlayers(
      String tricode, List<GamePlayerStats> players, bool isHome,
      [bool selected = false]) {
    TextStyle textStyle = Theme.of(context).textTheme.body1;
    textStyle = (selected)
        ? textStyle.copyWith(fontWeight: FontWeight.bold)
        : textStyle;

    return InkWell(
      child: Container(
        child: Text(tricode, style: textStyle),
        padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0),
      ),
      onTap: () {
        this.setState(() {
          this.sortedIndex = null;
          this.players = players;
          this.homePlayersSelected = isHome;
        });
      },
    );
  }

  List<DataCell> _getDataCells(int index) {
    return <DataCell>[
      DataCell(Row(children: <Widget>[
        CircleAvatar(
            backgroundColor: Colors.white,
            child: FadeInImage.assetNetwork(
              placeholder: "assets/players_placeholder.png",
              image: NBALinks.getPlayerProfilePic(this.players[index].personId),
            )),
        Container(width: 10.0),
        Text(
            this.players[index].lastName + ", " + this.players[index].firstName)
      ])),
      DataCell(Text(this.players[index].min)),
      DataCell(Text(this.players[index].pts)),
      DataCell(Text(this.players[index].totReb)),
      DataCell(Text(this.players[index].ast)),
      DataCell(Text(this.players[index].fgm)),
      DataCell(Text(this.players[index].fga)),
      DataCell(Text(this.players[index].fgp)),
      DataCell(Text(this.players[index].ftm)),
      DataCell(Text(this.players[index].fta)),
      DataCell(Text(this.players[index].ftp)),
      DataCell(Text(this.players[index].tpm)),
      DataCell(Text(this.players[index].tpa)),
      DataCell(Text(this.players[index].tpp)),
      DataCell(Text(this.players[index].offReb)),
      DataCell(Text(this.players[index].defReb)),
      DataCell(Text(this.players[index].stl)),
      DataCell(Text(this.players[index].blk)),
      DataCell(Text(this.players[index].to)),
      DataCell(Text(this.players[index].plusMinus)),
      DataCell(Text(this.players[index].pf))
    ];
  }

  List<DataColumn> _getDataColumns() {
    return <DataColumn>[
      DataColumn(label: const Text('PLAYER')),
      DataColumn(label: const Text('MIN')),
      DataColumn(label: const Text('PTS')),
      DataColumn(label: const Text('REB')),
      DataColumn(label: const Text('AST')),
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
      DataColumn(label: const Text('STL')),
      DataColumn(label: const Text('BLK')),
      DataColumn(label: const Text('TO')),
      DataColumn(label: const Text('+/-')),
      DataColumn(label: const Text('PF')),
    ];
  }
}
