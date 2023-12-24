// database/database_helper.dart

import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:contacts_buddy/models/contact.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'contacts.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT,
        email TEXT
      )
    ''');
  }

  Future<List<Contact>> getContacts() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('contacts', orderBy: 'name COLLATE NOCASE');
    return List.generate(maps.length, (i) {
      return Contact(
        id: maps[i]['id'],
        name: maps[i]['name'],
        phone: maps[i]['phone'],
        email: maps[i]['email'],
      );
    });
  }

  Future<void> insertContact(Contact contact) async {
    final Database db = await database;
    await db.insert('contacts', contact.toMap());
  }

  Future<void> updateContact(Contact contact) async {
    final Database db = await database;
    await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteContact(int id) async {
    final Database db = await database;
    await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Contact>> searchContacts(String query) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contacts',
      where: "name LIKE ?",
      whereArgs: ['%$query%'],
    );

    var x = List.generate(maps.length, (i) {
      return Contact(
        id: maps[i]['id'],
        name: maps[i]['name'],
        phone: maps[i]['phone'],
        email: maps[i]['email'],
      );
    });
    print("==================");
    print(x);
    print("==================");
    return x;
  }
}
