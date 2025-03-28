import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/domain/entities/note.dart';
import 'package:note_app/features/presentation/bloc/note_bloc.dart';
import 'package:note_app/features/presentation/bloc/note_event.dart';
import 'package:note_app/features/presentation/bloc/note_state.dart';
import 'package:note_app/features/presentation/pages/note_detail_page.dart';
import 'package:note_app/features/presentation/widgets/note_list_item.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  TransactionFilter _currentFilter = TransactionFilter.all;

  @override
  void initState() {
    super.initState();
    // Load transactions when the page initializes
    context.read<TransactionBloc>().add(GetAllTransactionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mening qarzlarim'),
        elevation: 0,
        actions: [
          // Filter dropdown
          PopupMenuButton<TransactionFilter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (TransactionFilter filter) {
              setState(() {
                _currentFilter = filter;
              });
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<TransactionFilter>>[
                  const PopupMenuItem<TransactionFilter>(
                    value: TransactionFilter.all,
                    child: Text('Hammasi'),
                  ),
                  const PopupMenuItem<TransactionFilter>(
                    value: TransactionFilter.borrowed,
                    child: Text('Qarz olingan'),
                  ),
                  const PopupMenuItem<TransactionFilter>(
                    value: TransactionFilter.lent,
                    child: Text('Qarz berilgan'),
                  ),
                  const PopupMenuItem<TransactionFilter>(
                    value: TransactionFilter.unpaid,
                    child: Text("To'lanmagan"),
                  ),
                  const PopupMenuItem<TransactionFilter>(
                    value: TransactionFilter.paid,
                    child: Text("To'langan"),
                  ),
                ],
          ),
        ],
      ),
      body: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          // Add your listener code here
        },
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionsLoaded) {
            // Filter transactions based on selected filter
            final transactions = _filterTransactions(state.transactions);

            if (transactions.isEmpty) {
              return _buildEmptyState();
            }

            return _buildTransactionList(transactions);
          } else if (state is TransactionError) {
            return Center(child: Text(state.message));
          }

          // Initial or unknown state
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteDetailPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    switch (_currentFilter) {
      case TransactionFilter.borrowed:
        return transactions
            .where((tx) => tx.type == TransactionType.borrowed)
            .toList();
      case TransactionFilter.lent:
        return transactions
            .where((tx) => tx.type == TransactionType.lent)
            .toList();
      case TransactionFilter.unpaid:
        return transactions.where((tx) => !tx.isPaid).toList();
      case TransactionFilter.paid:
        return transactions.where((tx) => tx.isPaid).toList();
      case TransactionFilter.all:
      // ignore: unreachable_switch_default
      default:
        return transactions;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_add, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Hozircha qarzlar yoq',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return NoteListItem(
          transaction: transaction,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteDetailPage(note: transaction),
              ),
            );
          },
          onDelete: () {
            context.read<TransactionBloc>().add(
              DeleteTransactionEvent(id: transaction.id!),
            );
          },
        );
      },
    );
  }
}

enum TransactionFilter { all, borrowed, lent, paid, unpaid }
