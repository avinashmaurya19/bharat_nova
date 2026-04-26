import 'package:bharat_nova/widgets/app_colors.dart';
import 'package:bharat_nova/widgets/shimmer_widget.dart';
import 'package:flutter/widgets.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 4,
      padding: const EdgeInsets.symmetric(vertical: 8),
      separatorBuilder: (context, index) =>
          Container(height: 6, color: AppColors.background),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ShimmerContainer(
                    width: 40,
                    height: 40,
                    borderRadius: 20,
                    baseColor: AppColors.borderColor,
                    highlightColor: AppColors.white.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerContainer(
                        width: 140,
                        height: 12,
                        borderRadius: 4,
                        baseColor: AppColors.borderColor,
                        highlightColor: AppColors.white.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: 6),
                      ShimmerContainer(
                        width: 100,
                        height: 10,
                        borderRadius: 4,
                        baseColor: AppColors.borderColor,
                        highlightColor: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ShimmerContainer(
                width: double.infinity,
                height: 12,
                borderRadius: 4,
                baseColor: AppColors.borderColor,
                highlightColor: AppColors.white.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 6),
              ShimmerContainer(
                width: double.infinity,
                height: 12,
                borderRadius: 4,
                baseColor: AppColors.borderColor,
                highlightColor: AppColors.white.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 12),
              ShimmerContainer(
                width: double.infinity,
                height: 200,
                borderRadius: 12,
                baseColor: AppColors.borderColor,
                highlightColor: AppColors.white.withValues(alpha: 0.7),
              ),
            ],
          ),
        );
      },
    );
  }
}
