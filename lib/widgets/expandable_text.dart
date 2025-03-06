import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_ai_task/theme.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLength;

  const ExpandableText({super.key, required this.text, this.maxLength = 100});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isOverflowing = widget.text.length > widget.maxLength;

    // If expanded, show full text
    if (_expanded || !isOverflowing) {
      return RichText(
        text: TextSpan(
          text: widget.text,
          style: TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
          children:
              isOverflowing
                  ? [
                    TextSpan(
                      text: " See less",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () => setState(() => _expanded = false),
                    ),
                  ]
                  : [],
        ),
      );
    }

    // If collapsed, truncate text and add "See More"
    String truncatedText = "${widget.text.substring(0, widget.maxLength)}...";

    return RichText(
      text: TextSpan(
        text: truncatedText,
        style: TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
        children: [
          TextSpan(
            text: " See More",
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () => setState(() => _expanded = true),
          ),
        ],
      ),
    );
  }
}
