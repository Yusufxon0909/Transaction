// lib/data/repositories/note_repository_impl.dart
import 'package:dartz/dartz.dart';
import '/core/errors/exceptions.dart';
import '/core/errors/failures.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_local_data_source.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;

  NoteRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, int>> deleteNote(int id) async {
    try {
      final result = await localDataSource.deleteNote(id);
      return Right(result);
    } on AppDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  // In note_repository_impl.dart
  @override
  Future<Either<Failure, List<Transaction>>> getAllNotes() async {
    try {
      print('Fetching all notes from database');
      final result = await localDataSource.getAllNotes();
      print('Fetched ${result.length} notes successfully');
      return Right(result);
    } catch (e) {
      print('Error fetching notes: $e');
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> addNote(Transaction note) async {
    try {
      print('Adding note to database: ${note.title}');
      final noteModel = TransactionModel.fromEntity(note);
      final result = await localDataSource.addNote(noteModel);
      print('Note added successfully with id: $result');
      return Right(result);
    } catch (e) {
      print('Error adding note: $e');
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getNoteById(int id) async {
    try {
      final result = await localDataSource.getNoteById(id);
      return Right(result);
    } on AppDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> updateNote(Transaction note) async {
    try {
      final noteModel = TransactionModel.fromEntity(note);
      final result = await localDataSource.updateNote(noteModel);
      return Right(result);
    } on AppDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
