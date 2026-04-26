part of 'feed_bloc.dart';

sealed class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class GetFeedEvent extends FeedEvent {
  const GetFeedEvent();
}

class GetLocationEvent extends FeedEvent {
  const GetLocationEvent();
}

class LoadMoreFeedEvent extends FeedEvent {
  const LoadMoreFeedEvent();
}

class TogglePostLikeEvent extends FeedEvent {
  const TogglePostLikeEvent({required this.postId});

  final int postId;

  @override
  List<Object?> get props => [postId];
}


