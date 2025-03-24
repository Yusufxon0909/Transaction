import 'package:dartz/dartz.dart';
import 'package:note_app/core/errors/failures.dart';
import 'package:note_app/core/usecases/usecase.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

class AddNote implements UseCase<int, Transaction> {
  final NoteRepository repository;

  AddNote(this.repository);

  @override
  Future<Either<Failure, int>> call(Transaction note) async {
    return await repository.addNote(note);
  }
}
