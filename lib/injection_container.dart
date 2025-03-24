import 'package:get_it/get_it.dart';
import 'package:note_app/features/data/datasources/note_local_data_source.dart';
import 'package:note_app/features/data/repositories/note_repository_impl.dart';
import 'package:note_app/features/domain/repositories/note_repository.dart';
import 'package:note_app/features/domain/usecases/add_note.dart';
import 'package:note_app/features/domain/usecases/delete_note.dart';
import 'package:note_app/features/domain/usecases/get_all_notes.dart';
import 'package:note_app/features/domain/usecases/update_note.dart';
import 'package:note_app/features/presentation/bloc/note_bloc.dart';

// Service locator
final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => TransactionBloc(
      getAllTransactions: sl(),
      addTransaction: sl(),
      updateTransaction: sl(),
      deleteTransaction: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllNotes(sl()));
  sl.registerLazySingleton(() => AddNote(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));

  // Repository
  sl.registerLazySingleton<NoteRepository>(() => NoteRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<NoteLocalDataSource>(
    () => NoteLocalDataSourceImpl(),
  );

  // External
  // You may need to register external dependencies like database instances here
  // For example:
  // sl.registerLazySingleton(() => DatabaseHelper());

  print('Dependency injection initialized');
}
