import 'package:contacts_buddy/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmOptionText; // New parameter for the confirm option text
  final VoidCallback onConfirm;

  ConfirmationDialog({
    required this.title,
    required this.content,
    this.confirmOptionText =
        'Confirm', // Default value for the confirm option text
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CustomButton(
          text: 'Cancel',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CustomButton(
          text: confirmOptionText,
          onPressed: onConfirm,
          isPrimary: confirmOptionText == 'Save' ||
              confirmOptionText == 'Update', // Check for primary appearance
          isDanger:
              confirmOptionText == 'Delete', // Check for danger appearance
        ),
      ],
    );
  }
}
