import 'package:flutter/material.dart';
import 'package:contacts_buddy/database/database_helper.dart';
import 'package:contacts_buddy/models/contact.dart';
import 'package:contacts_buddy/widgets/confirmation_dialog.dart'; // Import the ConfirmationDialog

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    searchFocus.requestFocus();
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          textCapitalization: TextCapitalization.words,
          controller: searchController,
          focusNode: searchFocus,
          decoration: InputDecoration(
            hintText: 'Search contacts',
          ),
          onChanged: (query) {
            setState(() {});
            // Implement search functionality based on the query
          },
        ),
      ),
      body: FutureBuilder<List<Contact>>(
        future: DatabaseHelper.instance.searchContacts(searchController.text),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No matching contacts found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Contact contact = snapshot.data![index];
              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.phone),
                onTap: () {
                  _showContactOptions(context, contact);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showContactOptions(BuildContext context, Contact contact) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Name: ${contact.name}'),
              ),
              ListTile(
                title: Text('Phone: ${contact.phone}'),
              ),
              ListTile(
                title: Text('Email: ${contact.email}'),
              ),
              SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () {
              //     // Handle edit action
              //     Navigator.pop(context);
              //     _editContact(context, contact);
              //   },
              //   child: Text('Edit Contact'),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     // Handle delete action
              //     Navigator.pop(context);
              //     _deleteContact(context, contact);
              //   },
              //   style: ElevatedButton.styleFrom(primary: Colors.red),
              //   child: Text('Delete Contact'),
              // ),
              // CustomButton(
              //   text: 'Edit Contact',
              //   onPressed: () {
              //     _editContact(context, contact);
              //   },
              //   isPrimary: true,
              // ),
              // CustomButton(
              //   text: 'Delete Contact',
              //   onPressed: () {
              //     _deleteContact(context, contact);
              //   },
              //   isDanger: true,
              // ),
            ],
          ),
        );
      },
    );
  }

  void _editContact(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Confirm Edit',
          content: 'Are you sure you want to edit this contact?',
          onConfirm: () {
            // Add your logic for editing here
            Navigator.pop(context); // Close the dialog
          },
        );
      },
    );
  }

  void _deleteContact(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Confirm Delete',
          content: 'Are you sure you want to delete this contact?',
          onConfirm: () {
            // Add your logic for deleting here
            Navigator.pop(context); // Close the dialog
          },
        );
      },
    );
  }
}
