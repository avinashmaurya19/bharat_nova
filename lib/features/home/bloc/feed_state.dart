part of 'feed_bloc.dart';

class FeedLoading extends FeedState {
  const FeedLoading();

  @override
  List<Object?> get props => [];
}

class FeedSuccess extends FeedState {
  const FeedSuccess({required this.posts});

  final List<Posts> posts;

  @override
  List<Object?> get props => [posts];
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
