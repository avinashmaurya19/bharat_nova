part of 'feed_bloc.dart';

class FeedLoading extends FeedState {
  const FeedLoading();

  @override
  List<Object?> get props => [];
}

class FeedSuccess extends FeedState {
  const FeedSuccess({
    required this.posts,
    this.likedPostIds = const <int>{},
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  final List<Posts> posts;
  final Set<int> likedPostIds;
  final bool isLoadingMore;
  final bool hasReachedMax;

  FeedSuccess copyWith({
    List<Posts>? posts,
    Set<int>? likedPostIds,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return FeedSuccess(
      posts: posts ?? this.posts,
      likedPostIds: likedPostIds ?? this.likedPostIds,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [posts, likedPostIds, isLoadingMore, hasReachedMax];
}

class FeedError extends FeedState {
  const FeedError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class FeedCityUpdated extends FeedState {
  const FeedCityUpdated({required this.city});

  final String city;

  @override
  List<Object?> get props => [city];
}

sealed class FeedState extends Equatable {
  const FeedState();
}
