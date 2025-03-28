import 'package:equatable/equatable.dart';
import 'package:note_app/features/domain/entities/note.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List get props => [];
}

class GetAllTransactionsEvent extends TransactionEvent {}

class AddTransactionEvent extends TransactionEvent {
  final String title;
  final double amount;
  final String currency;
  final DateTime date;
  final bool isPaid;
  final TransactionType type;
  final DateTime? dueDate;
  final String? notes;

  const AddTransactionEvent({
    required this.title,
    required this.amount,
    required this.currency,
    required this.date,
    required this.isPaid,
    required this.type,
    this.dueDate,
    this.notes,
  });

  @override
  List get props => [
    title,
    amount,
    currency,
    date,
    isPaid,
    type,
    dueDate,
    notes,
  ];
}

class UpdateTransactionEvent extends TransactionEvent {
  final Transaction transaction;

  const UpdateTransactionEvent({required this.transaction});

  @override
  List get props => [transaction];
}

class DeleteTransactionEvent extends TransactionEvent {
  final int id;

  const DeleteTransactionEvent({required this.id});

  @override
  List get props => [id];
}
