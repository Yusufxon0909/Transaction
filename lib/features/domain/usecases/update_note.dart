import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '/core/usecases/usecase.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

class UpdateNote implements UseCase<int, Transaction> {
  final NoteRepository repository;

  UpdateNote(this.repository);

  @override
  Future<Either<Failure, int>> call(Transaction note) async {
    return await repository.updateNote(note);
  }
}
