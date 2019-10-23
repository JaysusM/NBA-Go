import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/models/models.dart';

class PlayerSeasons extends StatelessWidget {
  final PlayerDetail playerDetail;
  List<Team> teams;

  PlayerSeasons({@required this.playerDetail}) : assert(playerDetail != null);

  @override
  Widget build(BuildContext context) {
    this.teams =
        (BlocProvider.of<TeamListBloc>(context).currentState as TeamListLoaded)
            .teams;
    return Container(
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                horizontalMargin: 0.0,
                columnSpacing: 10.0,
                columns: _getDataColumns(),
                rows: _getDataRows(),
              ))),
      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    );
  }

  List<DataColumn> _getDataColumns() {
    return <DataColumn>[
      DataColumn(label: Text("Season")),
      DataColumn(label: Text("Team")),
      DataColumn(label: Text("PPG")),
      DataColumn(label: Text("RPG")),
      DataColumn(label: Text("APG")),
      DataColumn(label: Text("BPG")),
      DataColumn(label: Text("SPG")),
      DataColumn(label: Text("FG%")),
      DataColumn(label: Text("3P%")),
      DataColumn(label: Text("FT%"))
    ];
  }

  List<DataRow> _getDataRows() {
    return this
        .playerDetail
        .allSeasonStats
        .map((season) {
          Team team = this.teams.firstWhere((team) => team.teamId == season.teamId);
          return DataRow(cells: <DataCell>[
              DataCell(Text(season.seasonYear.toString())),
              DataCell(Text(team.tricode.toUpperCase())),
              DataCell(Text(season.ppg.toString())),
              DataCell(Text(season.rpg.toString())),
              DataCell(Text(season.apg.toString())),
              DataCell(Text(season.bpg.toString())),
              DataCell(Text(season.spg.toString())),
              DataCell(Text(season.fgp.toString())),
              DataCell(Text(season.tpp.toString())),
              DataCell(Text(season.ftp.toString())),
            ]);
        })
        .toList();
  }
}
