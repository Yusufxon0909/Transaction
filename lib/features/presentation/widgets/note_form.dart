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
  TransactionType _transactionType = TransactionType.borrowed;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _amountController = TextEditingController(
      text: widget.note?.amount != null ? widget.note!.amount.toString() : '',
    );
    _notesController = TextEditingController(text: widget.note?.notes ?? '');

    if (widget.note != null) {
      _currency = widget.note!.currency;
      _isPaid = widget.note!.isPaid;
      _date = widget.note!.date;
      _dueDate = widget.note!.dueDate;
      _transactionType = widget.note!.type;
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
            // Transaction Type Selection
            Row(
              children: [
                Expanded(
                  child: RadioListTile<TransactionType>(
                    title: const Text('Qarz olish'),
                    //   subtitle: const Text('Pulni sizga berishgan'),
                    value: TransactionType.borrowed,
                    groupValue: _transactionType,
                    onChanged: (TransactionType? value) {
                      if (value != null) {
                        setState(() {
                          _transactionType = value;
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<TransactionType>(
                    title: const Text('Qarz berish'),
                    // subtitle: const Text('Siz pulni bergansiz'),
                    value: TransactionType.lent,
                    groupValue: _transactionType,
                    onChanged: (TransactionType? value) {
                      if (value != null) {
                        setState(() {
                          _transactionType = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText:
                    _transactionType == TransactionType.borrowed
                        ? 'Kimdan'
                        : 'Kimga',
                border: const OutlineInputBorder(),
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
                  flex: 7,
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Miqdori',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Iltimos maydonni toldiring';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Raqam kiriting';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: _currency,
                    decoration: const InputDecoration(
                      labelText: 'Valyuta',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'som', child: Text('SOM')),
                      DropdownMenuItem(value: 'usd', child: Text('USD')),
                      DropdownMenuItem(value: 'eur', child: Text('EUR')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _currency = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null && picked != _date) {
                        setState(() {
                          _date = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Sana',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('dd/MM/yyyy').format(_date)),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap:
                        _isPaid
                            ? null
                            : () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _dueDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setState(() {
                                  _dueDate = picked;
                                });
                              }
                            },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Qaytarish sanasi',
                        border: const OutlineInputBorder(),
                        enabled: !_isPaid,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _dueDate == null
                                ? 'Tanlang'
                                : DateFormat('dd/MM/yyyy').format(_dueDate!),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Toʻlangan'),
              value: _isPaid,
              onChanged: (bool value) {
                setState(() {
                  _isPaid = value;
                  if (_isPaid) {
                    _dueDate = null;
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Eslatmalar',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                child: Text(widget.note == null ? 'Qoshish' : 'Yangilash'),
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
            type: _transactionType,
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
              type: _transactionType,
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
