import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import 'package:nba_go/models/models.dart';
import 'package:nba_go/repositories/game_list_repository.dart';

abstract class GameListEvent extends Equatable {
    GameListEvent([List props = const []]) : super(props);
}

class FetchGameList extends GameListEvent {}
class RefreshGameList extends GameListEvent {
  final DateTime refreshDate;

  RefreshGameList({this.refreshDate});
}

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

  // We will use this attribute in future "RefreshGameList" events
  // Refreshing content when we change date
  DateTime _lastLoadedDate;

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
      yield GameListLoading();
      try {
        List<Game> games;
        if(event.refreshDate != null)
          games = await gameListRepository.getGameListWithDate(event.refreshDate);
        else if(this._lastLoadedDate != null)
          games = await gameListRepository.getGameListWithDate(this._lastLoadedDate);
        else
          games = await gameListRepository.getGameList();
        yield GameListLoaded(games: games);
      } catch (error) {
        yield GameListError(error: error);
      }
    }
  }
}