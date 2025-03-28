import 'package:flutter/material.dart';
import 'package:note_app/features/domain/entities/note.dart';

class NoteListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteListItem({
    Key? key,
    required this.transaction,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set colors based on transaction type
    final Color typeColor =
        transaction.type == TransactionType.borrowed
            ? Colors.red.shade100
            : Colors.blue.shade100;

    final Color typeTextColor =
        transaction.type == TransactionType.borrowed
            ? Colors.red.shade700
            : Colors.blue.shade700;

    final String typeText =
        transaction.type == TransactionType.borrowed
            ? "Qarz olindi"
            : "Qarz berildi";

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      transaction.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      typeText,
                      style: TextStyle(
                        color: typeTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          transaction.isPaid
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      transaction.isPaid ? "To'langan" : "To'lanmagan",
                      style: TextStyle(
                        color:
                            transaction.isPaid
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    color: Colors.red,
                    iconSize: 20,
                    splashRadius: 24,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${transaction.amount.toStringAsFixed(2)} ${transaction.currency.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          transaction.type == TransactionType.borrowed
                              ? Colors.red
                              : Colors.blue,
                    ),
                  ),
                ],
              ),
              // Rest of the code remains the same
            ],
          ),
        ),
      ),
    );
  }
}
