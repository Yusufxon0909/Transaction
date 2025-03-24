import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (transaction.notes != null && transaction.notes!.isNotEmpty)
                Text(
                  transaction.notes!,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Olindi: ${DateFormat('MMM dd, yyyy').format(transaction.date)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  if (transaction.dueDate != null)
                    Text(
                      'Muddat: ${DateFormat('MMM dd, yyyy').format(transaction.dueDate!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            transaction.dueDate!.isBefore(DateTime.now())
                                ? Colors.red
                                : Colors.grey.shade600,
                        fontWeight:
                            transaction.dueDate!.isBefore(DateTime.now())
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
