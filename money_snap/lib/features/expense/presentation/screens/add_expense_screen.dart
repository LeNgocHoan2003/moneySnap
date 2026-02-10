import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/money_utils.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/entities/expense.dart';
import '../stores/expense_store.dart';

/// Screen: add new expense (one picture + description only).
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({
    super.key,
    required this.store,
    required this.onSaved,
  });

  final ExpenseStore store;
  final VoidCallback onSaved;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String? _imagePath;
  bool _saving = false;

  /// Pick exactly one image from camera (one picture at a time).
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.camera);
    if (xfile != null) {
      setState(() => _imagePath = xfile.path);
    }
  }

  Future<void> _save() async {
    if (_imagePath == null || _imagePath!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.expenseTakeOnePictureFirst)),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final amount = MoneyUtils.parseAmount(_descriptionController.text);
      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: _imagePath!,
        description: _descriptionController.text,
        date: DateTime.now(),
        amount: amount,
      );
      await widget.store.addExpense(expense);
      if (mounted) {
        widget.onSaved();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(context.t.expenseAddExpense)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Single image capture only (one picture at a time)
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imagePath != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(_imagePath!), fit: BoxFit.cover),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: IconButton.filled(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: _pickImage,
                              tooltip: context.t.expenseReplacePicture,
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              Icon(Icons.camera_alt, size: 48, color: colorScheme.onSurfaceVariant),
                            const SizedBox(height: 8),
                              Text(
                                context.t.expenseTapToTakePicture,
                                style: TextStyle(color: colorScheme.onSurfaceVariant),
                              ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: context.t.expenseDescription,
                border: const OutlineInputBorder(),
                hintText: context.t.expenseNumbersOnly,
              ),
              validator: (v) {
                final t = context.t;
                if (v == null || v.isEmpty) return t.errorsEnterDescription;
                if (!RegExp(r'^\d+$').hasMatch(v)) return t.expenseNumbersOnly;
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(context.t.commonSave),
            ),
          ],
        ),
      ),
    );
  }
}
