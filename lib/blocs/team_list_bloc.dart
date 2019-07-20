import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import 'package:nba_go/models/models.dart';
import 'package:nba_go/repositories/team_list_repository.dart';

abstract class TeamListEvent extends Equatable {
    TeamListEvent([List props = const []]) : super(props);
}

class FetchTeamList extends TeamListEvent {}

abstract class TeamListState extends Equatable {
    TeamListState([List props = const []]) : super(props);
}

class TeamListEmpty extends TeamListState {}
class TeamListLoading extends TeamListState {}
class TeamListError extends TeamListState {
  final String error;

  TeamListError({@required this.error})
    : assert(error != null),
      super([error]);
}
class TeamListLoaded extends TeamListState {
  final List<Team> teams;

  TeamListLoaded({@required this.teams})
    : assert(teams != null),
      super([teams]);

}

class TeamListBloc extends Bloc<TeamListEvent, TeamListState> {
  final TeamListRepository teamListRepository;

  TeamListBloc({@required this.teamListRepository})
    : assert(teamListRepository != null);

  @override
  TeamListState get initialState => TeamListEmpty();

  @override
  Stream<TeamListState> mapEventToState(TeamListEvent event) async* {
    if (event is FetchTeamList) {
      yield TeamListLoading();
      try {
        final List<Team> teams = await teamListRepository.getTeamList();
        yield TeamListLoaded(teams: teams);
      } catch (error) {
        yield TeamListError(error: error);
      }
    }
  }
}