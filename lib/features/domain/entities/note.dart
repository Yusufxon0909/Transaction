class Transaction {
  final int? id;
  final String title;
  final double amount;
  final String currency; // "som" or "usd"
  final DateTime date;
  final bool isPaid;
  final DateTime? dueDate;
  final String? notes;

  const Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.date,
    required this.isPaid,
    this.dueDate,
    this.notes,
  });
}
