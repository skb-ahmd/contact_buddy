// screens/edit_contact_screen.dart

import 'package:contacts_buddy/widgets/confirmation_dialog.dart';
import 'package:contacts_buddy/widgets/custom_button.dart';
import 'package:contacts_buddy/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:contacts_buddy/models/contact.dart';
import 'package:contacts_buddy/database/database_helper.dart';

class EditContactScreen extends StatefulWidget {
  final Contact contact;

  EditContactScreen({required this.contact});

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contact.name);
    phoneController = TextEditingController(text: widget.contact.phone);
    emailController = TextEditingController(text: widget.contact.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomInputField(
              controller: nameController,
              label: 'Name',
              icon: Icons.person,
            ),
            CustomInputField(
              controller: phoneController,
              label: 'Phone No',
              icon: Icons.phone,
              keyboardType: TextInputType.number,
            ),
            CustomInputField(
              controller: emailController,
              label: 'Mail Address',
              icon: Icons.email,
            ),
            SizedBox(height: 16),
            CustomButton(
              text: 'Save Changes',
              onPressed: () {
                _saveChanges(context);
              },
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges(BuildContext context) {
    // Show the confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          confirmOptionText: "Save",
          title: 'Confirm Save',
          content: 'Are you sure you want to save changes?',
          onConfirm: () {
            // Validate the inputs before saving changes
            if (_validateInputs()) {
              Contact updatedContact = widget.contact.copyWith(
                name: nameController.text,
                phone: phoneController.text,
                email: emailController.text,
              );

              DatabaseHelper.instance.updateContact(updatedContact).then((_) {
                Navigator.pop(context); // Close the EditContactScreen
                Navigator.pop(context); // Close the EditContactScreen
              });
            }
          },
        );
      },
    );
  }

  bool _validateInputs() {
    if (nameController.text.trim().isEmpty) {
      _showErrorDialog('Please enter a name.');
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      _showErrorDialog('Please enter a phone number.');
      return false;
    }

    // Validate phone number format
    final phoneRegex = RegExp(r'^[0-9]+$');
    if (!phoneRegex.hasMatch(phoneController.text.trim())) {
      _showErrorDialog('Please enter a valid phone number.');
      return false;
    }

    if (emailController.text.trim().isNotEmpty) {
      // Validate email format
      final emailRegex =
          RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
      if (!emailRegex.hasMatch(emailController.text.trim())) {
        _showErrorDialog('Please enter a valid email address.');
        return false;
      }
    }

    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
