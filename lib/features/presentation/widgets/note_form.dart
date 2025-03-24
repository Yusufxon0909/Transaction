import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note_app/features/domain/entities/note.dart';
import 'package:note_app/features/presentation/bloc/note_bloc.dart';
import 'package:note_app/features/presentation/bloc/note_event.dart';

class NoteForm extends StatefulWidget {
  final Transaction? note;

  const NoteForm({Key? key, this.note}) : super(key: key);

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  String _currency = 'som';
  bool _isPaid = false;
  DateTime _date = DateTime.now();
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _amountController = TextEditingController(
      text: widget.note?.amount.toString() ?? '',
    );
    _notesController = TextEditingController(text: widget.note?.notes ?? '');

    if (widget.note != null) {
      _currency = widget.note!.currency;
      _isPaid = widget.note!.isPaid;
      _date = widget.note!.date;
      _dueDate = widget.note!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Kimdan',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Iltimos maydonni toldiring';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Miqdor',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Iltimos miqdorni kiriting';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _currency,
                    decoration: const InputDecoration(
                      labelText: 'Valyuta',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'som', child: Text('Som')),
                      DropdownMenuItem(value: 'usd', child: Text('USD')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _currency = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Olingan vaqt'),
                    subtitle: Text(DateFormat('MMM dd, yyyy').format(_date)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _date = selectedDate;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            if (!_isPaid) ...[
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Muddat'),
                subtitle:
                    _dueDate != null
                        ? Text(DateFormat('MMM dd, yyyy').format(_dueDate!))
                        : const Text('Not set'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate:
                        _dueDate ?? DateTime.now().add(const Duration(days: 7)),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _dueDate = selectedDate;
                    });
                  }
                },
              ),
            ],
            CheckboxListTile(
              title: const Text("To'landi"),
              value: _isPaid,
              onChanged: (value) {
                setState(() {
                  _isPaid = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Eslatma',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                child: Text(widget.note == null ? 'Qoshish' : 'Yanqilash'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      if (widget.note == null) {
        // Add new transaction
        context.read<TransactionBloc>().add(
          AddTransactionEvent(
            title: _titleController.text,
            amount: double.parse(_amountController.text),
            currency: _currency,
            date: _date,
            isPaid: _isPaid,
            dueDate: _isPaid ? null : _dueDate,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
          ),
        );
      } else {
        // Update existing transaction
        context.read<TransactionBloc>().add(
          UpdateTransactionEvent(
            transaction: Transaction(
              id: widget.note!.id,
              title: _titleController.text,
              amount: double.parse(_amountController.text),
              currency: _currency,
              date: _date,
              isPaid: _isPaid,
              dueDate: _isPaid ? null : _dueDate,
              notes:
                  _notesController.text.isEmpty ? null : _notesController.text,
            ),
          ),
        );
      }
      Navigator.pop(context);
    }
  }
}
