import 'package:dartz/dartz.dart';
import 'package:note_app/core/errors/failures.dart';
import '../entities/note.dart';

abstract class NoteRepository {
  Future<Either<Failure, List<Transaction>>> getAllNotes();
  Future<Either<Failure, Transaction>> getNoteById(int id);
  Future<Either<Failure, int>> addNote(Transaction note);
  Future<Either<Failure, int>> updateNote(Transaction note);
  Future<Either<Failure, int>> deleteNote(int id);
}
