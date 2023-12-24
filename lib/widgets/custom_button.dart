import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDanger;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
    this.isDanger = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    Color textColor;

    if (isPrimary) {
      buttonColor = Theme.of(context).primaryColor;
      textColor = Colors.white;
    } else if (isDanger) {
      buttonColor = Colors.red;
      textColor = Colors.white;
    } else {
      buttonColor = Colors.transparent; // No background color
      textColor = Theme.of(context)
          .primaryColor; // Text color matching theme's primary color
    }

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: textColor,
        side: !isPrimary &&  !isDanger
            ? BorderSide(
                color: Theme.of(context).primaryColor,
              )
            : BorderSide.none,
      ),
      child: Text(text),
    );
  }
}
