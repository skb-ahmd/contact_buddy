// screens/home_screen.dart

import 'package:contacts_buddy/screens/edit_contact_screen.dart';
import 'package:contacts_buddy/widgets/confirmation_dialog.dart';
import 'package:contacts_buddy/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:contacts_buddy/models/contact.dart';
import 'package:contacts_buddy/screens/add_contact_screen.dart';
import 'package:contacts_buddy/screens/search_screen.dart';
import 'package:contacts_buddy/database/database_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Contact>> contacts;

  @override
  void initState() {
    super.initState();
    refreshContactList();
  }

  Future<void> refreshContactList() async {
    setState(() {
      contacts = DatabaseHelper.instance.getContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts Buddy'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Contact>>(
        future: contacts,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No contacts available. Add some contacts!'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Contact contact = snapshot.data![index];
              String firstLetter =
                  contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '';
              return ListTile(
                leading: CircleAvatar(
                  child: Text(firstLetter),
                ),
                title: Text(contact.name),
                subtitle: Text(contact.phone),
                onTap: () {
                  _showContactDetails(context, contact);
                },
                // Add more details or actions as needed
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactScreen()),
          ).then((_) => refreshContactList());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showContactDetails(BuildContext context, Contact contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
              CustomButton(
                text: 'Edit Contact',
                onPressed: () {
                  _editContact(context, contact);
                },
                isPrimary: true,
              ),
              CustomButton(
                text: 'Delete Contact',
                onPressed: () {
                  _deleteContact(context, contact.id!);
                },
                isDanger: true,
              ),
            ],
          ),
        );
      },
    );
  }

  void _editContact(BuildContext context, Contact contact) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EditContactScreen(contact: contact),
      ),
    ).then((_) => refreshContactList());
  }

  void _deleteContact(BuildContext context, int contactId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          confirmOptionText: "Delete",
          title: 'Confirm Delete',
          content: 'Are you sure you want to delete this contact?',
          onConfirm: () {
            DatabaseHelper.instance.deleteContact(contactId).then((_) {
              Navigator.pop(context); // Close the confirmation dialog
              Navigator.pop(context); // Close the modal
              refreshContactList(); // Refresh the contact list
            });
          },
        );
      },
    );
  }
}
