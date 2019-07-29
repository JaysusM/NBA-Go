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
  // We will use it to filter players after team changed
  List<Player> shownPlayers;
  // Will be useful to keep selected team after page changes
  Team selectedTeam;

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
        this.allLoadedPlayers = this.shownPlayers = players;
        this.selectedTeam = null;
        yield PlayerListLoaded(players: players);
      } catch (error) {
        yield PlayerListError(error: error.toString());
      }
    } else if (event is FilterPlayerListByValue) {

      yield PlayerListLoading();
      try {
        yield PlayerListLoaded(players: this.shownPlayers.where((player) => player.fullName.toLowerCase().contains(event.filter)).toList());
      } catch(error) {
        yield PlayerListError(error: error.toString());
      }
    } else if (event is FilterPlayerListByTeam) {
      yield PlayerListLoading();
      try {
        if(allLoadedPlayers == null)
          this.allLoadedPlayers = this.shownPlayers = await playerListRepository.fetchPlayerList();
        if (event.team != null) {
          this.shownPlayers = allLoadedPlayers.where((player) => player.teamId == event.team.teamId).toList();
          this.selectedTeam = event.team;
          yield PlayerListLoaded(players: shownPlayers);
        } else {
          this.shownPlayers = allLoadedPlayers;
          this.selectedTeam = null;
          yield PlayerListLoaded(players: allLoadedPlayers);
        }
      } catch(error) {
        yield PlayerListError(error: error.toString());
      }
    }
  }
}