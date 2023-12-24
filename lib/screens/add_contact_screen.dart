// screens/add_contact_screen.dart

import 'package:contacts_buddy/models/contact.dart';
import 'package:contacts_buddy/widgets/custom_button.dart';
import 'package:contacts_buddy/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:contacts_buddy/database/database_helper.dart';

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Email validation function
  bool isEmailValid(String email) {
    if (email.trim().isEmpty) {
      return true; // Allow empty email
    }

    String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  // Phone validation function
  bool isPhoneValid(String phone) {
    if (phone.trim().isEmpty) {
      return false; // Phone number is empty
    }

    final phoneRegex = RegExp(r'^[0-9]+$');
    return phoneRegex.hasMatch(phone.trim());
  }

  // Show an alert dialog for invalid input
  void showInvalidInputAlert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Invalid Input'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              text: 'Save Contact',
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  showInvalidInputAlert('Please Enter a Name');
                  return;
                }
                // Validate email and phone
                if (!isEmailValid(emailController.text)) {
                  showInvalidInputAlert('Invalid email format');
                  return;
                }

                if (!isPhoneValid(phoneController.text)) {
                  if (phoneController.text.trim().isEmpty) {
                    showInvalidInputAlert('Enter Mobile Number');
                  } else {
                    showInvalidInputAlert(
                        'Phone number should not contain letters');
                  }
                  return;
                }
                Contact newContact = Contact(
                    name: nameController.text,
                    phone: phoneController.text,
                    email: emailController.text);

                // All validations passed, insert the contact
                DatabaseHelper.instance.insertContact(newContact);

                Navigator.pop(context);
              },
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }
}
