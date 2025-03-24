import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '/core/usecases/usecase.dart';
import '../repositories/note_repository.dart';

class DeleteNote implements UseCase<int, int> {
  final NoteRepository repository;

  DeleteNote(this.repository);

  @override
  Future<Either<Failure, int>> call(int id) async {
    return await repository.deleteNote(id);
  }
}
