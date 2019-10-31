import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/player_details_bloc.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/ui/widgets/widgets.dart';

class PlayerDetailScreen extends StatelessWidget {
  final Player player;

  const PlayerDetailScreen(
      {@required this.player})
      : assert(player != null);

  @override
  Widget build(BuildContext context) {
    PlayerDetailBloc playerDetailBloc = BlocProvider.of<PlayerDetailBloc>(context);
    playerDetailBloc.dispatch(FetchPlayerDetail(player: this.player));
    return SafeArea(
        child: Scaffold(
      body: BlocBuilder(
        bloc: playerDetailBloc,
        builder: (BuildContext context, PlayerDetailState state) {
          if (state is PlayerDetailLoading)
            return LoadingWidget();
          else if (state is PlayerDetailLoaded)
            return PlayerDetailView(playerDetail: state.playerDetail);
          else if (state is PlayerDetailError)
            return ErrorMessageWidget(error: state.error);
          return ErrorMessageWidget(error: 'Unknown state $state');
        },
      ),
    ));
  }
}

class PlayerDetailView extends StatelessWidget {
  final PlayerDetail playerDetail;

  PlayerDetailView({@required this.playerDetail})
    : assert(playerDetail != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(child: PlayerDetailBanner(playerDetail: playerDetail), height: 190.0),
        SizedBox(child: PlayerStats(playerDetail: playerDetail), height: 250.0),
        Expanded(child: PlayerSeasons(playerDetail: playerDetail))
      ]
    );
  }
}
