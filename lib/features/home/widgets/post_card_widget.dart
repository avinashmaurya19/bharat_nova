import 'dart:developer';

import 'package:bharat_nova/features/home/data/post_model.dart';
import 'package:bharat_nova/widgets/app_colors.dart';
import 'package:bharat_nova/widgets/read_more_widget.dart';
import 'package:bharat_nova/widgets/shimmer_widget.dart';
import 'package:bharat_nova/widgets/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, required this.showReposted});

  final Posts post;
  final bool showReposted;

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        'https://picsum.photos/id/${(post.id ?? 0 % 50) + 10}/700/450';

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //reposted
          if (showReposted) ...[
            Row(
              children: [
                Icon(
                  Icons.repeat_rounded,
                  size: 14,
                  color: AppColors.secondoryText,
                ),
                const SizedBox(width: 4),
                Text(
                  'You Reposted',
                  style: AppTextStyle.regularStyle(
                    fontSize: 12,
                    color: AppColors.secondoryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          //user row
          PostUserRow(userId: post.userId ?? 0),
          const SizedBox(height: 10),
          _PostBody(title: post.title ?? '', body: post.body ?? ''),
          //tags
          if (post.tags?.isNotEmpty ?? false) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: post.tags!.isNotEmpty
                  ? post.tags!
                        .take(4)
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '#$tag',
                              style: AppTextStyle.regularStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        )
                        .toList()
                  : [],
            ),
          ],
          const SizedBox(height: 12),
          //image and reactions
          Container(
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.borderColor, width: 1),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1.5,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          errorListener: (error) {
                            log('Error loading image: $error');
                          },
                          placeholder: (context, url) => ShimmerContainer(
                            width: double.infinity,
                            height: double.infinity,
                            borderRadius: 12,
                            baseColor: AppColors.borderColor,
                            highlightColor: AppColors.white.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.borderColor,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '3/10',
                            style: AppTextStyle.mediumStyle(
                              fontSize: 11,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final isActive = index == 0;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isActive ? 7 : 6,
                      height: isActive ? 7 : 6,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.borderColor,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ReactionItem(
                        icon: Icons.favorite_border,
                        count: post.reactions?.likes ?? 0,
                      ),
                      const SizedBox(width: 16),
                      _ReactionItem(
                        icon: Icons.chat_bubble_outline,
                        count: post.reactions?.dislikes ?? 0,
                      ),
                      const SizedBox(width: 16),
                      _ReactionItem(
                        icon: Icons.repeat_rounded,
                        count: post.reactions?.dislikes ?? 0,
                      ),
                      const SizedBox(width: 16),
                      _ReactionItem(
                        icon: Icons.remove_red_eye_outlined,
                        count: post.views ?? 0,
                      ),
                      const SizedBox(width: 16),

                      Row(
                        children: [
                          Icon(
                            Icons.reply_outlined,
                            size: 16,
                            color: AppColors.secondoryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Share',
                            style: AppTextStyle.regularStyle(
                              fontSize: 12,
                              color: AppColors.secondoryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostUserRow extends StatelessWidget {
  const PostUserRow({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.borderColor,
                backgroundImage: CachedNetworkImageProvider(
                  'https://i.pravatar.cc/100?img=${(userId % 20) + 1}',
                  errorListener: (error) {
                    log('Error loading avatar: $error');
                  },
                ),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    size: 14,
                    color: Color(0xFF1D9BF0),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'User $userId',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.semiBoldStyle(
                        fontSize: 14,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.verified_rounded,
                    size: 14,
                    color: Color(0xFF1D9BF0),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '@user_$userId',
                style: AppTextStyle.regularStyle(
                  fontSize: 12,
                  color: AppColors.secondoryText,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 12,
                    color: AppColors.secondoryText,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    'Mumbai, India',
                    style: AppTextStyle.regularStyle(
                      fontSize: 12,
                      color: AppColors.secondoryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '1d',
          style: AppTextStyle.regularStyle(
            fontSize: 12,
            color: AppColors.secondoryText,
          ),
        ),
        const SizedBox(width: 6),
        Icon(Icons.more_vert, size: 18, color: AppColors.secondoryText),
      ],
    );
  }
}

class _PostBody extends StatelessWidget {
  const _PostBody({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final fullText = [title, body].where((t) => t.isNotEmpty).join('. ');
    return ReadMoreWidget(text: fullText, limit: 100);
  }
}

class _ReactionItem extends StatelessWidget {
  const _ReactionItem({required this.icon, required this.count});

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.secondoryText),
        const SizedBox(width: 4),
        Text(
          _formatCount(count),
          style: AppTextStyle.regularStyle(
            fontSize: 12,
            color: AppColors.secondoryText,
          ),
        ),
      ],
    );
  }

  String _formatCount(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}
