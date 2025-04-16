import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onActionPressed;
  final Widget child;
  final EdgeInsets? padding;

  const SectionContainer({
    super.key,
    required this.title,
    this.actionText = 'View All',
    this.onActionPressed,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onActionPressed != null)
          TextButton(
            onPressed: onActionPressed,
            child: Row(
              children: [
                Text(
                  actionText,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
      ],
    );
  }
}