import 'package:equatable/equatable.dart';

enum TransactionType { borrowed, lent }

class Transaction extends Equatable {
  final int? id;
  final String title;
  final double amount;
  final String currency;
  final DateTime date;
  final bool isPaid;
  final TransactionType type;
  final DateTime? dueDate;
  final String? notes;

  const Transaction({
    this.id,
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
  List<Object?> get props => [
    id,
    title,
    amount,
    currency,
    date,
    isPaid,
    type,
    dueDate,
    notes,
  ];

  Transaction copyWith({
    int? id,
    String? title,
    double? amount,
    String? currency,
    DateTime? date,
    bool? isPaid,
    TransactionType? type,
    DateTime? dueDate,
    String? notes,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      date: date ?? this.date,
      isPaid: isPaid ?? this.isPaid,
      type: type ?? this.type,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
    );
  }
}
