# Bharat Nova

Bharat Nova is a Flutter social-feed style app built from a Figma-driven UI.
It includes feed loading, pull-to-refresh, pagination, local like toggling, location-based city display, and bottom navigation.

## Tech Stack

- Flutter (Material 3)
- Dart
- `flutter_bloc` for state management
- `dio` for API requests
- `go_router` for app routing
- `location` + `geocoding` for city detection
- `cached_network_image` for optimized image loading

## Getting Started

### Prerequisites

- Flutter SDK (stable)
- Dart SDK (bundled with Flutter)
- Android Studio / Xcode / VS Code or Cursor

### Run Locally

```bash
flutter pub get
flutter run
```

## Approach Used

The implementation follows a feature-first and layered approach:

- **Presentation layer** handles UI widgets/pages and user interactions.
- **State layer** uses BLoC/Cubit to manage feed lifecycle, pagination, likes, and bottom-nav state.
- **Data layer** encapsulates remote API access and model mapping.

### Why this approach

- Keeps business logic outside UI widgets.
- Improves maintainability and testability.
- Makes it easier to scale feature-by-feature.

### Feed flow overview

1. UI dispatches events (`GetFeedEvent`, `LoadMoreFeedEvent`, `TogglePostLikeEvent`, `GetLocationEvent`).
2. `FeedBloc` processes events and updates states (`FeedLoading`, `FeedSuccess`, `FeedError`, `FeedCityUpdated`).
3. `FeedRepository` fetches paginated posts from `https://dummyjson.com/posts`.
4. UI rebuilds using reactive `BlocBuilder` widgets.

## Project Structure

```text
lib/
  main.dart
  routes.dart
  widgets/
    app_colors.dart
    text_style.dart
    read_more_widget.dart
    shimmer_widget.dart
  features/
    home/
      data/
        feed_repository.dart
        location_service.dart
        post_model.dart
      bloc/
        feed_bloc.dart
        feed_event.dart
        feed_state.dart
        cubit/
          bottom_nav_cubit.dart
          bottom_nav_state.dart
      presentation/
        home_page.dart
        bottom_nav_page.dart
      widgets/
        post_card_widget.dart
        shimmer_loading_widget.dart
        error_widget.dart
```

## Implemented Features

- Figma-aligned social feed UI
- Infinite scroll (load more on scroll)
- Pull-to-refresh
- Like toggle (UI state)
- Shimmer loading placeholders
- Error view with retry action
- City detection using device location permissions
- Bottom navigation with center action button
- `go_router` based routing setup

## Confirmation Note

- The UI matches the Figma design.
- All required features have been implemented.
