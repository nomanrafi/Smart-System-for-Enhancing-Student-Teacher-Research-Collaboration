import 'package:flutter/material.dart';

class ResearchHubLogo extends StatelessWidget {
  final double fontSize;
  final bool showTagline;
  
  const ResearchHubLogo({
    super.key, 
    this.fontSize = 40,
    this.showTagline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'Sans', // Adjust font family as needed
            ),
            children: const [
              TextSpan(
                text: 'Research',
                style: TextStyle(color: Color(0xFF00113F)), // Dark navy blue
              ),
              TextSpan(
                text: 'Hub',
                style: TextStyle(color: Color.fromARGB(255, 114, 6, 214)), // Orange
              ),
            ],
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 12),
          const Text(
            'D I S C O V E R .   L E A R N .\nC O L L A B O R A T E',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 4,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFF8C5A), // Same orange as "Hub"
            ),
          ),
        ],
      ],
    );
  }
}