import 'package:dartz/dartz.dart';
import 'package:note_app/core/errors/failures.dart';
import 'package:note_app/core/usecases/usecase.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

class GetAllNotes implements UseCase<List<Transaction>, NoParams> {
  final NoteRepository repository;

  GetAllNotes(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(NoParams params) async {
    return await repository.getAllNotes();
  }
}
