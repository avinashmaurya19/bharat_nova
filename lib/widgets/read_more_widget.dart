import 'package:bharat_nova/widgets/app_colors.dart';
import 'package:bharat_nova/widgets/text_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ReadMoreWidget extends StatefulWidget {
  const ReadMoreWidget({
    required this.text,
    this.limit = 100,
    super.key,
  });

  final String text;
  final int limit;

  @override
  State<ReadMoreWidget> createState() => _ReadMoreWidgetState();
}

class _ReadMoreWidgetState extends State<ReadMoreWidget> {
  late final ValueNotifier<bool> _isExpanded;
  late final TapGestureRecognizer _toggleRecognizer;

  @override
  void initState() {
    super.initState();
    _isExpanded = ValueNotifier<bool>(false);
    _toggleRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _isExpanded.value = !_isExpanded.value;
      };
  }

  @override
  void dispose() {
    _toggleRecognizer.dispose();
    _isExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullText = widget.text.trim();
    if (fullText.isEmpty) {
      return const SizedBox.shrink();
    }

    final canExpand = fullText.length > widget.limit;

    return ValueListenableBuilder<bool>(
      valueListenable: _isExpanded,
      builder: (context, isExpanded, _) {
        final collapsedText = canExpand
            ? '${fullText.substring(0, widget.limit)}...'
            : fullText;
        final visibleText = isExpanded ? fullText : collapsedText;

        return RichText(
          text: TextSpan(
            style: AppTextStyle.regularStyle(
              fontSize: 13.5,
              color: AppColors.rateTextColor,
              height: 1.4,
            ),
            children: [
              TextSpan(text: visibleText),
              if (canExpand)
                TextSpan(
                  text: isExpanded ? ' Read Less' : ' Read More',
                  style: AppTextStyle.semiBoldStyle(
                    fontSize: 13.5,
                    color: AppColors.primary,
                  ),
                  recognizer: _toggleRecognizer,
                ),
            ],
          ),
        );
      },
    );
  }
}