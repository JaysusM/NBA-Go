import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/repositories/repositories.dart';

abstract class GameStatsEvent extends Equatable {
  GameStatsEvent([List props = const []]) : super(props);
}

class FetchGameStats extends GameStatsEvent {
  
  final String gameDate, gameId;
  FetchGameStats({@required this.gameDate, @required this.gameId})
    : assert(gameDate != null),
      assert(gameId != null);
}

abstract class GameStatsState extends Equatable {
  GameStatsState([List props = const []]) : super(props);
}

class GameStatsEmpty extends GameStatsState {}
class GameStatsLoading extends GameStatsState {}
class GameStatsLoaded extends GameStatsState {
  final GameDetail gameStats;

  GameStatsLoaded({@required this.gameStats})
    : assert (GameStatsEmpty() != null);  
}
class GameStatsError extends GameStatsState {
  final String error;

  GameStatsError({@required this.error});
}

class GameStatsBloc extends Bloc<GameStatsEvent, GameStatsState> {
  
  final GameDetailRepository gameStatsRepository;
  String _lastGameDate, _lastGameId;
  
  GameStatsBloc({@required this.gameStatsRepository})
    : assert(gameStatsRepository != null);

  @override
  GameStatsState get initialState => GameStatsEmpty();

  @override
  Stream<GameStatsState> mapEventToState(GameStatsEvent event) async* {
    if(event is FetchGameStats) {
      yield GameStatsLoading();
      try {
        GameDetail gameDetail = await this.gameStatsRepository.getGameDetail(event.gameDate, event.gameId);
        this._lastGameId = event.gameId;
        this._lastGameDate = event.gameDate;
        yield GameStatsLoaded(gameStats: gameDetail);
      } catch (error) {
        yield GameStatsError(error: error.toString());
      }
    }
  }

}
