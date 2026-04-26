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
    on<LoadMoreFeedEvent>(_onLoadMore);
    on<TogglePostLikeEvent>(_onTogglePostLike);
  }

  final FeedRepository _feedRepository;
  final _locationService = LocationService();
  static const int _pageSize = 10;
  String currentCity = 'Detecting...';
  FeedSuccess? _latestFeedSuccess;
  int _currentPage = 1;

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
    final previousLikedPostIds = _latestFeedSuccess?.likedPostIds ?? <int>{};
    emit(const FeedLoading());
    try {
      final posts = await _feedRepository.fetchPosts(page: 1, limit: _pageSize);
      _currentPage = 1;
      final successState = FeedSuccess(
        posts: posts,
        likedPostIds: previousLikedPostIds,
        hasReachedMax: posts.length < _pageSize,
      );
      _latestFeedSuccess = successState;
      emit(successState);
    } catch (_) {
      emit(
        const FeedError(message: 'Could not load feed. Pull down to retry.'),
      );
    }
  }

  Future<void> _onLoadMore(
    LoadMoreFeedEvent event,
    Emitter<FeedState> emit,
  ) async {
    final current = state is FeedSuccess ? state as FeedSuccess : _latestFeedSuccess;
    if (current == null || current.isLoadingMore || current.hasReachedMax) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    try {
      final nextPage = _currentPage + 1;
      final nextPosts = await _feedRepository.fetchPosts(
        page: nextPage,
        limit: _pageSize,
      );
      _currentPage = nextPage;
      final updated = current.copyWith(
        posts: [...current.posts, ...nextPosts],
        isLoadingMore: false,
        hasReachedMax: nextPosts.length < _pageSize,
      );
      _latestFeedSuccess = updated;
      emit(updated);
    } catch (_) {
      final rollback = current.copyWith(isLoadingMore: false);
      _latestFeedSuccess = rollback;
      emit(rollback);
    }
  }

  void _onTogglePostLike(TogglePostLikeEvent event, Emitter<FeedState> emit) {
    final current = state is FeedSuccess ? state as FeedSuccess : _latestFeedSuccess;
    if (current == null) return;
    final updatedLiked = Set<int>.from(current.likedPostIds);
    if (updatedLiked.contains(event.postId)) {
      updatedLiked.remove(event.postId);
    } else {
      updatedLiked.add(event.postId);
    }
    final updatedSuccess = current.copyWith(likedPostIds: updatedLiked);
    _latestFeedSuccess = updatedSuccess;
    emit(updatedSuccess);
  }

  Future<String> _resolveCity() async {
    try {
      return await _locationService.requestPermissionsAndResolveCity();
    } catch (_) {
      return 'Unknown';
    }
  }
}
