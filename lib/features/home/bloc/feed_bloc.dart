import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/feed_repository.dart';
import '../data/location_service.dart';
import '../data/post_model.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc(this._feedRepository) : super(const FeedLoading()) {
    on<GetFeedEvent>(_onStarted);
    on<GetLocationEvent>(_onCityRequested);
  }

  final FeedRepository _feedRepository;
  final _locationService = LocationService();
  static const int _pageSize = 10;
  String currentCity = 'Detecting...';

  Future<void> _onStarted(GetFeedEvent event, Emitter<FeedState> emit) async {
    await _getFeed(emit);
  }

  Future<void> _onCityRequested(
    GetLocationEvent event,
    Emitter<FeedState> emit,
  ) async {
    currentCity = await _resolveCity();
    emit(FeedCityUpdated(city: currentCity));
  }


  Future<void> _getFeed(Emitter<FeedState> emit) async {
    emit(const FeedLoading());
    try {
      final posts = await _feedRepository.fetchPosts(page: 1, limit: _pageSize);
      emit(FeedSuccess(posts: posts));
    } catch (_) {
      emit(
        const FeedError(message: 'Could not load feed. Pull down to retry.'),
      );
    }
  }

  Future<String> _resolveCity() async {
    try {
      return await _locationService.requestPermissionsAndResolveCity();
    } catch (_) {
      return 'Unknown';
    }
  }
}
