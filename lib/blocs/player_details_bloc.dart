import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nba_go/blocs/game_list_bloc.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/repositories/repositories.dart';

abstract class PlayerDetailEvent extends Equatable {
  PlayerDetailEvent([List props = const []]) : super(props);
}

class FetchPlayerDetail extends PlayerDetailEvent {
  
  final Player player;
  FetchPlayerDetail({@required this.player})
    : assert(player != null);
}

abstract class PlayerDetailState extends Equatable {
  PlayerDetailState([List props = const []]) : super(props);
}

class PlayerDetailEmpty extends PlayerDetailState {}
class PlayerDetailLoading extends PlayerDetailState {}
class PlayerDetailLoaded extends PlayerDetailState {
  final PlayerDetail playerDetail;

  PlayerDetailLoaded({@required this.playerDetail})
    : assert (playerDetail != null);  
}
class PlayerDetailError extends PlayerDetailState {
  final String error;

  PlayerDetailError({@required this.error});
}

class PlayerDetailBloc extends Bloc<PlayerDetailEvent, PlayerDetailState> {
  
  final PlayerDetailRepository playerDetailRepository;
  
  PlayerDetailBloc({@required this.playerDetailRepository})
    : assert(playerDetailRepository != null);

  @override
  PlayerDetailState get initialState => PlayerDetailEmpty();

  @override
  Stream<PlayerDetailState> mapEventToState(PlayerDetailEvent event) async* {
    if(event is FetchPlayerDetail) {
      yield PlayerDetailLoading();
      try {
        PlayerDetail playerDetail = await this.playerDetailRepository.fetchPlayerDetail(event.player);
        yield PlayerDetailLoaded(playerDetail: playerDetail);
      } catch (error) {
        yield PlayerDetailError(error: error.toString());
      }
    }
  }

}
