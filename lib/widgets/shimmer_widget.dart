import 'package:bharat_nova/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// Base shimmer effect widget that can be used to create shimmer loading effects
class ShimmerWidget extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerWidget({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? AppColors.grey30;
    final highlightColor = widget.highlightColor ?? AppColors.borderColor;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 + _animation.value * 2, 0.0),
              end: Alignment(1.0 + _animation.value * 2, 0.0),
              colors: [
                baseColor,
                baseColor,
                highlightColor,
                baseColor,
                baseColor,
              ],
              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

/// Shimmer container widget - a simple rectangular shimmer placeholder
class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 0,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.grey30,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Interest card shimmer - matches the interest card layout
class InterestCardShimmer extends StatelessWidget {
  const InterestCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ShimmerContainer(width: 96, height: 96, borderRadius: 26),
        const SizedBox(height: 6),
        const ShimmerContainer(width: 60, height: 14, borderRadius: 4),
      ],
    );
  }
}

/// Language tile shimmer - matches the language tile layout
class LanguageTileShimmer extends StatelessWidget {
  const LanguageTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey30,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey30, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Circular image shimmer
          ShimmerContainer(width: 48, height: 48, borderRadius: 24),
          const SizedBox(width: 16),
          // Text content shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerContainer(
                  width: double.infinity,
                  height: 16,
                  borderRadius: 4,
                ),
                const SizedBox(height: 4),
                const ShimmerContainer(width: 120, height: 12, borderRadius: 4),
              ],
            ),
          ),
          // "Mark as Default" text and checkbox shimmer
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ShimmerContainer(width: 90, height: 12, borderRadius: 4),
              const SizedBox(width: 12),
              const ShimmerContainer(width: 20, height: 20, borderRadius: 4),
            ],
          ),
        ],
      ),
    );
  }
}

/// Avatar choice shimmer - matches the circular avatar tile layout
class AvatarChoiceShimmer extends StatelessWidget {
  const AvatarChoiceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.grey30,
      ),
      child: ClipOval(
        child: ShimmerWidget(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.grey30,
            ),
          ),
        ),
      ),
    );
  }
}

/// Brand and Model grid shimmer - matches the brand/model grid layout
class BrandModelGridShimmer extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const BrandModelGridShimmer({
    super.key,
    this.itemCount = 6,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
        childAspectRatio: 1.2,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ShimmerContainer(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 8,
          baseColor: AppColors.background,
          highlightColor: AppColors.white.withValues(alpha: 0.5),
        );
      },
    );
  }
}

/// Single Brand/Model item shimmer
class SingleBrandModelShimmer extends StatelessWidget {
  const SingleBrandModelShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      width: double.infinity,
      height: double.infinity,
      borderRadius: 8,
      baseColor: AppColors.background,
      highlightColor: AppColors.white.withValues(alpha: 0.5),
    );
  }
}
