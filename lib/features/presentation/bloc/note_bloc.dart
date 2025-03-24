import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/domain/entities/note.dart';
import 'package:note_app/features/domain/usecases/add_note.dart';
import 'package:note_app/features/domain/usecases/delete_note.dart';
import 'package:note_app/features/domain/usecases/get_all_notes.dart';
import 'package:note_app/features/domain/usecases/update_note.dart';
import 'package:note_app/features/presentation/bloc/note_event.dart';
import 'package:note_app/features/presentation/bloc/note_state.dart';
import '../../../core/usecases/usecase.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetAllNotes getAllTransactions;
  final AddNote addTransaction;
  final UpdateNote updateTransaction;
  final DeleteNote deleteTransaction;

  TransactionBloc({
    required this.getAllTransactions,
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
  }) : super(TransactionInitial()) {
    on<GetAllTransactionsEvent>(_onGetAllTransactions);
    on<AddTransactionEvent>(_onAddTransaction);
    on<UpdateTransactionEvent>(_onUpdateTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
  }

  Future<void> _onGetAllTransactions(
    GetAllTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await getAllTransactions(NoParams());

    result.fold(
      (failure) => emit(
        TransactionError(
          message: 'Failed to load transactions: ${failure.message}',
        ),
      ),
      (transactions) => emit(TransactionsLoaded(transactions: transactions)),
    );
  }

  Future<void> _onAddTransaction(
    AddTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    final transaction = Transaction(
      title: event.title,
      amount: event.amount,
      currency: event.currency,
      date: event.date,
      isPaid: event.isPaid,
      dueDate: event.dueDate,
      notes: event.notes,
    );

    print('Adding transaction: ${transaction.title}');
    final result = await addTransaction(transaction);

    result.fold(
      (failure) => emit(
        TransactionError(
          message: 'Failed to add transaction: ${failure.message}',
        ),
      ),
      (_) {
        print('Transaction added successfully');
        add(GetAllTransactionsEvent());
        emit(
          const TransactionOperationSuccess(
            message: 'Transaction added successfully',
          ),
        );
      },
    );
  }

  Future<void> _onUpdateTransaction(
    UpdateTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    final result = await updateTransaction(event.transaction);

    result.fold(
      (failure) => emit(
        TransactionError(
          message: 'Failed to update transaction: ${failure.message}',
        ),
      ),
      (_) {
        add(GetAllTransactionsEvent());
        emit(
          const TransactionOperationSuccess(
            message: 'Transaction updated successfully',
          ),
        );
      },
    );
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    final result = await deleteTransaction(event.id);

    result.fold(
      (failure) => emit(
        TransactionError(
          message: 'Failed to delete transaction: ${failure.message}',
        ),
      ),
      (_) {
        add(GetAllTransactionsEvent());
        emit(
          const TransactionOperationSuccess(
            message: 'Transaction deleted successfully',
          ),
        );
      },
    );
  }
}
