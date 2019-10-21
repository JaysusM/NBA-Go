import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nba_go/blocs/player_details_bloc.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/ui/widgets/widgets.dart';

class PlayerDetailScreen extends StatelessWidget {
  final Player player;
  final PlayerDetailBloc playerDetailBloc;
  final Team team;

  const PlayerDetailScreen(
      {@required this.playerDetailBloc, @required this.player,
      @required this.team})
      : assert(playerDetailBloc != null),
        assert(player != null),
        assert(team != null);

  @override
  Widget build(BuildContext context) {
    playerDetailBloc.dispatch(FetchPlayerDetail(player: this.player));
    return SafeArea(
        child: Scaffold(
      body: BlocBuilder(
        bloc: playerDetailBloc,
        builder: (BuildContext context, PlayerDetailState state) {
          if (state is PlayerDetailLoading)
            return LoadingWidget();
          else if (state is PlayerDetailLoaded)
            return PlayerDetailView(playerDetail: state.playerDetail, playerTeam: this.team);
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
  final Team playerTeam;

  PlayerDetailView({@required this.playerDetail, @required this.playerTeam})
    : assert(playerDetail != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(child: PlayerDetailBanner(playerDetail: playerDetail, playerTeam: this.playerTeam), height: 190.0),
        SizedBox(child: PlayerStats(playerDetail: playerDetail), height: 250.0),
        Expanded(child: PlayerSeasons(playerDetail: playerDetail))
      ]
    );
  }
}
