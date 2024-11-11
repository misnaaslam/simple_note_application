import 'dart:io';
import 'package:simple_note_application/model/notes_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';




class DatabaseConnection {
  static Database? _db;

  // Singleton database getter
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initialiseDatabase();
    return _db!;
  }

  // Initialize the database
  static Future<Database> initialiseDatabase() async {
    Directory applicationDirectory = await getApplicationDocumentsDirectory();
    String databasePath = "${applicationDirectory.path}/notes.db";

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE Notes (id INTEGER PRIMARY KEY, title TEXT, '
                'details TEXT, time INTEGER)');
      },
    );
  }

  // Get all notes
  static Future<List<NotesModel>> getDatabaseData() async {
    final db = await database;
    final result = await db.query("Notes");
    return result.map((e) => NotesModel.fromJson(e)).toList();
  }

  // Insert a new note
  static Future<void> insertData(NotesModel model) async {
    final db = await database;
    await db.insert("Notes", model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }


  // Delete a note
  static Future<void> deleteData(int id) async {
    final db = await database;
    await db.delete("Notes", where: "id = ?", whereArgs: [id]);
  }


  // Update a note
  static Future<void> updateData(NotesModel model, int id) async {
    final db = await database;
    await db.update(
      "Notes",
      model.toJson(),
      where: "id = ?",
      whereArgs: [id],
    );
  }

}



