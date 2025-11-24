import 'package:flutter/material.dart';

class PrimaryTextButton extends StatefulWidget {
  const PrimaryTextButton({
    required this.text,
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  State<PrimaryTextButton> createState() => _PrimaryTextButtonState();
}

class _PrimaryTextButtonState extends State<PrimaryTextButton> {
  bool _showIcon = false;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: widget.onPressed,
      onHover: (bool isHovering) {
        setState(() {
          _showIcon = isHovering;
        });
      },
      label: Text(widget.text),
      icon: _showIcon ? Icon(Icons.arrow_forward_ios) : null,
      iconAlignment: IconAlignment.end,
    );
  }
}
