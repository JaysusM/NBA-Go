import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:nba_go/models/models.dart';
import 'package:nba_go/repositories/repositories.dart';

abstract class PlayerListEvent extends Equatable {
  PlayerListEvent([List props = const []]): super(props);
}

class FetchPlayerList extends PlayerListEvent {}

class FilterPlayerListByValue extends PlayerListEvent {

  String filter;

  FilterPlayerListByValue(this.filter, [List props = const []]): super(props);
}

class FilterPlayerListByTeam extends PlayerListEvent {

  Team team;

  FilterPlayerListByTeam(this.team, [List props = const []]): super(props);
}

abstract class PlayerListState extends Equatable {
  PlayerListState([List props = const []]): super(props);
}

class PlayerListEmpty extends PlayerListState {}
class PlayerListLoading extends PlayerListState {}
class PlayerListLoaded extends PlayerListState {
  List<Player> players;

  PlayerListLoaded({@required this.players})
    : assert(players != null);
}
class PlayerListError extends PlayerListState {
  String error;

  PlayerListError({@required this.error})
    : assert(error != null);
}

class PlayerListBloc extends Bloc<PlayerListEvent, PlayerListState> {

  PlayerListRepository playerListRepository;
  
  // We will use this variable to filter players in event
  List<Player> allLoadedPlayers;

  PlayerListBloc({@required this.playerListRepository})
    : assert(playerListRepository != null);

  @override
  PlayerListState get initialState => PlayerListEmpty();

  @override
  Stream<PlayerListState> mapEventToState(PlayerListEvent event) async* {
    if(event is FetchPlayerList) {
      yield PlayerListLoading();
      try {
        List<Player> players = await playerListRepository.fetchPlayerList();
        this.allLoadedPlayers = players;
        yield PlayerListLoaded(players: players);
      } catch (error) {
        yield PlayerListError(error: error);
      }
    } else if (event is FilterPlayerListByValue) {
      yield PlayerListLoading();
      try {
        if(allLoadedPlayers == null)
          yield PlayerListError(error: 'Player list must be loaded first');
        else {
          yield PlayerListLoaded(players: allLoadedPlayers.where((player) => player.fullName.toLowerCase().contains(event.filter)).toList());
        }
      } catch(error) {
        yield PlayerListError(error: error);
      }
    }   
  }

}