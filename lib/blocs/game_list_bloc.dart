import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import 'package:nba_go/models/models.dart';
import 'package:nba_go/repositories/game_list_repository.dart';

abstract class GameListEvent extends Equatable {
    GameListEvent([List props = const []]) : super(props);
}

class FetchGameList extends GameListEvent {}
class RefreshGameList extends GameListEvent {}

abstract class GameListState extends Equatable {
    GameListState([List props = const []]) : super(props);
}

class GameListEmpty extends GameListState {}
class GameListLoading extends GameListState {}
class GameListError extends GameListState {
  final String error;

  GameListError({@required this.error})
    : assert(error != null),
      super([error]);
}
class GameListLoaded extends GameListState {
  final List<Game> games;

  GameListLoaded({@required this.games})
    : assert(games != null),
      super([games]);

}

class GameListBloc extends Bloc<GameListEvent, GameListState> {
  final GameListRepository gameListRepository;

  GameListBloc({@required this.gameListRepository})
    : assert(gameListRepository != null);

  @override
  GameListState get initialState => GameListEmpty();

  @override
  Stream<GameListState> mapEventToState(GameListEvent event) async* {
    if (event is FetchGameList) {
      yield GameListLoading();
      try {
        final List<Game> games = await gameListRepository.getGameList();
        yield GameListLoaded(games: games);
      } catch (error) {
        yield GameListError(error: error);
      }
    } else if (event is RefreshGameList) {
      try {
        final List<Game> games = await gameListRepository.getGameList();
        yield GameListLoaded(games: games);
      } catch (error) {
        yield GameListError(error: error);
      }
    }
  }
}