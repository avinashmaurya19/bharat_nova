import 'package:bharat_nova/features/home/widgets/error_widget.dart';
import 'package:bharat_nova/features/home/widgets/post_card_widget.dart';
import 'package:bharat_nova/features/home/widgets/shimmer_loading_widget.dart';
import 'package:bharat_nova/widgets/app_colors.dart';
import 'package:bharat_nova/widgets/text_style.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/feed_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<FeedBloc>().add(const GetLocationEvent());
    context.read<FeedBloc>().add(const GetFeedEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<FeedBloc>().add(const LoadMoreFeedEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const Icon(Icons.menu, size: 24, color: AppColors.black),
        title: RichText(
          text: TextSpan(
            style: AppTextStyle.boldStyle(
              fontSize: 16,
              letterSpacing: 1.2,
              color: AppColors.black,
            ),
            children: [
              const TextSpan(text: 'BHARATN'),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2.2),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              const TextSpan(text: 'VA'),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.location_on_rounded, size: 18, color: AppColors.primary),
          const SizedBox(width: 2),
          BlocBuilder<FeedBloc, FeedState>(
            buildWhen: (_, current) => current is FeedCityUpdated,
            builder: (context, state) {
              final city = context.read<FeedBloc>().currentCity;
              return Text(
                city,
                style: AppTextStyle.semiBoldStyle(
                  fontSize: 14,
                  color: AppColors.black,
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: Container(
          color: AppColors.white,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const TopTabs(),

                Expanded(
                  child: BlocBuilder<FeedBloc, FeedState>(
                    buildWhen: (_, current) => current is! FeedCityUpdated,
                    builder: (context, state) {
                      if (state is FeedLoading) {
                        return const ShimmerList();
                      }

                      if (state is FeedError) {
                        return ErrorWidget(
                          message: state.message,
                          onRetry: () => context.read<FeedBloc>().add(
                            const GetFeedEvent(),
                          ),
                        );
                      }

                      if (state is! FeedSuccess) {
                        return const SizedBox.shrink();
                      }

                      final posts = state.posts;
                      final totalItems = posts.length + (state.isLoadingMore ? 1 : 0);

                      return RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () async {
                          final feedBloc = context.read<FeedBloc>();
                          feedBloc.add(const GetFeedEvent());
                        },
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(top: 8, bottom: 124),
                          itemCount: totalItems,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            if (index >= posts.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              );
                            }
                            final postId = posts[index].id ?? index;
                            return PostCard(
                              post: posts[index],
                              showReposted: index == 0,
                              isLiked: state.likedPostIds.contains(postId),
                              onLikeToggle: () => context.read<FeedBloc>().add(
                                TogglePostLikeEvent(postId: postId),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopTabs extends StatefulWidget {
  const TopTabs({super.key});

  @override
  State<TopTabs> createState() => _TopTabsState();
}

class _TopTabsState extends State<TopTabs> {
  static const _tabs = ['Post', 'Nova', 'News', 'Article'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 42,
          child: Row(
            children: List.generate(_tabs.length, (index) {
              final isSelected = _selectedIndex == index;
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Center(
                    child: Text(
                      _tabs[index],
                      style: isSelected
                          ? AppTextStyle.semiBoldStyle(
                              fontSize: 14,
                              color: AppColors.black,
                            )
                          : AppTextStyle.mediumStyle(
                              fontSize: 14,
                              color: AppColors.secondoryText,
                            ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(
          height: 3,
          child: Stack(
            children: [
              Container(
                height: 1,
                color: AppColors.borderColor.withValues(alpha: 0.9),
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment(-1 + (_selectedIndex * 2 / 3), 0),
                child: FractionallySizedBox(
                  widthFactor: 0.25,
                  child: Container(height: 2.5, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
