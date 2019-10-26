import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import 'package:nba_go/models/models.dart';
import 'package:nba_go/repositories/standings_repository.dart';

abstract class StandingListEvent extends Equatable {
    StandingListEvent([List props = const []]) : super(props);
}

class FetchStandingList extends StandingListEvent {}

abstract class StandingListState extends Equatable {
    StandingListState([List props = const []]) : super(props);
}

class StandingListEmpty extends StandingListState {}
class StandingListLoading extends StandingListState {}
class StandingListError extends StandingListState {
  final String error;

  StandingListError({@required this.error})
    : assert(error != null),
      super([error]);
}
class StandingListLoaded extends StandingListState {
  final List<TeamStanding> standings;

  StandingListLoaded({@required this.standings})
    : assert(standings != null),
      super([standings]);

}

class StandingListBloc extends Bloc<StandingListEvent, StandingListState> {
  final StandingsRepository standingRepository;
  List<TeamStanding> standings;

  StandingListBloc({@required this.standingRepository})
    : assert(standingRepository != null);

  @override
  StandingListState get initialState => StandingListEmpty();

  @override
  Stream<StandingListState> mapEventToState(StandingListEvent event) async* {
    if (event is FetchStandingList) {
      yield StandingListLoading();
      try {
        final List<TeamStanding> standings = await standingRepository.fetchConferenceStandings();
        this.standings = standings;
        yield StandingListLoaded(standings: standings);
      } catch (error) {
        yield StandingListError(error: error.toString());
      }
    }
  }
}