import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/blocs.dart';
import 'package:nba_go/ui/widgets/widgets.dart';

class GameScreen extends StatelessWidget {

  final DateTime currentDate;

  GameScreen({@required this.currentDate}):
    assert(currentDate != null);

  @override
  Widget build(BuildContext context) {
    GameListBloc gameListBloc = BlocProvider.of<GameListBloc>(context);

    // This BlocBuilder is used to keep
    // selected date and games after page changes
    return BlocBuilder(
      bloc: gameListBloc,
      builder: (_, GameListState state) {
        DateTime selectedDate =
        (state is GameListLoaded) 
          ? state.selectedDate
          : this.currentDate;
        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(
                  child: DateSelector(selectedDate),
                  margin: EdgeInsets.only(bottom: 12.0)
                ),
                expandedHeight: 80.0,
              ),
            ];
          }, body: GameListView(),
        );
      },
    );
  }
}