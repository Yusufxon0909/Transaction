import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '/core/errors/exceptions.dart';
import '../models/note_model.dart';

abstract class NoteLocalDataSource {
  Future<List<TransactionModel>> getAllNotes();
  Future<TransactionModel> getNoteById(int id);
  Future<int> addNote(TransactionModel note);
  Future<int> updateNote(TransactionModel note);
  Future<int> deleteNote(int id);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final Directory documentsDirectory =
          await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, 'finances.db');

      print('Initializing database at: $path');

      // Use the appropriate database factory based on platform
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Use FFI for desktop platforms
        return await databaseFactoryFfi.openDatabase(
          path,
          options: OpenDatabaseOptions(version: 1, onCreate: _createDb),
        );
      } else {
        // Use regular sqflite for mobile platforms
        return await openDatabase(path, version: 1, onCreate: _createDb);
      }
    } catch (e) {
      print('Database initialization error: $e');
      rethrow;
    }
  }

  Future<void> _createDb(Database db, int version) async {
    print('Creating transactions table');
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        currency TEXT NOT NULL,
        date TEXT NOT NULL,
        is_paid INTEGER NOT NULL,
        due_date TEXT,
        notes TEXT
      )
    ''');
    print('Transactions table created successfully');
  }

  @override
  Future<int> deleteNote(int id) async {
    try {
      final db = await database;
      return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw AppDatabaseException(e.toString());
    }
  }

  @override
  Future<int> addNote(TransactionModel note) async {
    try {
      final db = await database;
      print('Adding transaction to database: ${note.title}');
      final id = await db.insert('transactions', note.toMap());
      print('Transaction added with ID: $id');
      return id;
    } catch (e) {
      print('Error in addNote: $e');
      throw AppDatabaseException('Failed to add transaction: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getAllNotes() async {
    try {
      final db = await database;
      print('Getting all transactions from database');
      final maps = await db.query('transactions', orderBy: 'date DESC');
      print('Retrieved ${maps.length} transactions from database');

      return List.generate(maps.length, (i) {
        try {
          return TransactionModel.fromMap(maps[i]);
        } catch (e) {
          print('Error parsing transaction at index $i: $e');
          throw AppDatabaseException('Failed to parse transaction data: $e');
        }
      });
    } catch (e) {
      print('Error in getAllNotes: $e');
      throw AppDatabaseException('Failed to get transactions: $e');
    }
  }

  @override
  Future<TransactionModel> getNoteById(int id) async {
    try {
      final db = await database;
      final maps = await db.query(
        'transactions',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return TransactionModel.fromMap(maps.first);
      } else {
        throw AppDatabaseException('Transaction not found');
      }
    } catch (e) {
      throw AppDatabaseException(e.toString());
    }
  }

  @override
  Future<int> updateNote(TransactionModel note) async {
    try {
      final db = await database;
      return await db.update(
        'transactions',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
    } catch (e) {
      throw AppDatabaseException(e.toString());
    }
  }
}
