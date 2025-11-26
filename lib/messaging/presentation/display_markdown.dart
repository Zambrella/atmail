import 'package:atmail/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class DisplayMarkdown extends StatelessWidget {
  const DisplayMarkdown({required this.data, super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Markdown(
      data: data,
      shrinkWrap: true,
      selectable: true,
      padding: EdgeInsets.zero,
    );
  }
}
