import 'package:note_app/features/domain/entities/note.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    int? id,
    required String title,
    required double amount,
    required String currency,
    required DateTime date,
    required bool isPaid,
    DateTime? dueDate,
    String? notes,
  }) : super(
         id: id,
         title: title,
         amount: amount,
         currency: currency,
         date: date,
         isPaid: isPaid,
         dueDate: dueDate,
         notes: notes,
       );

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      title: transaction.title,
      amount: transaction.amount,
      currency: transaction.currency,
      date: transaction.date,
      isPaid: transaction.isPaid,
      dueDate: transaction.dueDate,
      notes: transaction.notes,
    );
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      currency: map['currency'],
      date: DateTime.parse(map['date']),
      isPaid: map['is_paid'] == 1,
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'currency': currency,
      'date': date.toIso8601String(),
      'is_paid': isPaid ? 1 : 0,
      'due_date': dueDate?.toIso8601String(),
      'notes': notes,
    };
  }
}
