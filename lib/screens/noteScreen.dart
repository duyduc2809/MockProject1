import 'dart:math';

import 'package:flutter/material.dart';

import '../classes/Note.dart';

import '../helpers/SQLAccountHelper.dart';
import '../helpers/SQLNoteHelper.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> noteList = [];
  final int? _idAccount = SQLAccountHelper.currentAccount['id'];
  String? _categoryName;
  String? _priorityName;
  String? _statusName;
  String? _tempPlanDate;

  // List of categories, priorities, and statuses to be used for dropdowns
  List<String> categories = ['Category 1', 'Category 2', 'Category 3'];
  List<String> priorities = ['Priority 1', 'Priority 2', 'Priority 3'];
  List<String> statuses = ['Status 1', 'Status 2', 'Status 3'];
  //Load data notes.
  Future<void> _loadNotes() async {
    final data = await SQLNoteHelper.getNotes(accountId: _idAccount);

    setState(() {
      noteList = data;
    });
  }

  // DropdownButton onChanged callbacks to update the selected values
  void _onCategoryChanged(String? value) {
    setState(() {
      _categoryName = value;
    });
  }

  void _onPriorityChanged(String? value) {
    setState(() {
      _priorityName = value;
    });
  }

  void _onStatusChanged(String? value) {
    setState(() {
      _statusName = value;
    });
  }

  void _onSaveNote() {
    final newNote = Note(
      accountId: _idAccount,
      name: _nameController.text,
      categoryName: _categoryName,
      priorityName: _priorityName,
      statusName: _statusName,
      planDate: _tempPlanDate != null ? _tempPlanDate! : "",
    );

    setState(() {
      // Thêm ghi chú mới vào danh sách
      _addNote(newNote);
      _onClearNote();
      _loadNotes();
    });
  }

  void _onUpdateNote(int? id) {
    if (id != null) {
      _updateNote(id);
    }
  }

  // 1

  void _onClearNote() {
    setState(() {
      // Xóa nội dung trong các trường nhập liệu
      _nameController.clear();
      _onCategoryChanged(null);
      _onPriorityChanged(null);
      _onStatusChanged(null);
      _tempPlanDate = '';
    });
  }

  @override
  void initState() {
    super.initState();
    if (_idAccount != null) {
      _loadNotes();
    }
  }

  //validate
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required.';
    }
    return null; // Hợp lệ
  }

  String? _validateCategory(String? value) {
    if (value == null) {
      return 'Category is required.';
    }
    return null; // Hợp lệ
  }

  String? _validatePriority(String? value) {
    if (value == null) {
      return 'Priority is required.';
    }
    return null; // Hợp lệ
  }

  String? _validateStatus(String? value) {
    if (value == null) {
      return 'Status is required.';
    }
    return null; // Hợp lệ
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this note?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _deleteNote(id);
                Navigator.of(context).pop();
                // Show a snackbar to indicate successful deletion
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Note deleted successfully.")),
                );
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showNoteDialog(int? id) {
    if (id != null) {
      final existingNotes = noteList.firstWhere((note) => note['id'] == id);
      _nameController.text = existingNotes['name'];
      _categoryName = existingNotes['categoryName'];
      _priorityName = existingNotes['priorityName'];
      _statusName = existingNotes['statusName'];
      _tempPlanDate = existingNotes['planDate'];
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Note"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey, // Sử dụng GlobalKey cho Form
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                    validator: _validateName, // Sử dụng hàm validate riêng
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _categoryName,
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: _onCategoryChanged,
                    decoration: const InputDecoration(labelText: "Category"),
                    validator: _validateCategory, // Sử dụng hàm validate riêng
                  ),
                  DropdownButtonFormField<String>(
                    value: _priorityName,
                    items: priorities.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      );
                    }).toList(),
                    onChanged: _onPriorityChanged,
                    decoration: const InputDecoration(labelText: "Priority"),
                    validator: _validatePriority, // Sử dụng hàm validate riêng
                  ),
                  DropdownButtonFormField<String>(
                    value: _statusName,
                    items: statuses.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: _onStatusChanged,
                    decoration: const InputDecoration(labelText: "Status"),
                    validator: _validateStatus, // Sử dụng hàm validate riêng
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Show DateTimePicker and update _tempPlanDate
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _tempPlanDate = pickedDate.toIso8601String();
                        });
                      } 
                    },
                    child: Text(_tempPlanDate != null &&
                            _tempPlanDate!.isNotEmpty &&
                            _tempPlanDate! != ""
                        ? "Pick Plan Date: ${_tempPlanDate.toString().substring(0, 10)}"
                        : "Pick Plan Date"),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _onClearNote();
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Kiểm tra dữ liệu hợp lệ trước khi lưu hoặc cập nhật
                  if (_tempPlanDate == null || _tempPlanDate!.isEmpty) {
                    _showErrorDialog(context, "Please pick a plan date.");
                  } else {
                    if (id != null) {
                      _onUpdateNote(id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Note updated successfully.")),
                      );
                    } else {
                      _onSaveNote();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Note added successfully.")),
                      );
                    }
                    Navigator.of(context)
                        .pop(); // Đóng AlertDialog sau khi hoàn thành lưu hoặc cập nhật
                  }
                }
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Note")),
      body: ListView.builder(
        itemCount: noteList.length,
        itemBuilder: (context, index) {
          final note = noteList[index];
          return ListTile(
            title: Text(note['name'] ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category: ${note['categoryName'] ?? ''}'),
                Text('Priority: ${note['priorityName'] ?? ''}'),
                Text('Status: ${note['statusName'] ?? ''}'),
                Text(
                  'Plan Date: ${note['planDate'] != null ? note['planDate']!.toString().substring(0, 10) : ''}',
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showNoteDialog(note['id']);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(note['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNoteDialog(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _addNote(Note note) async {
    await SQLNoteHelper.createNote(note);
    _loadNotes();
  }

  Future<void> _updateNote(int id) async {
    await SQLNoteHelper.updateNote(Note(
      id: id,
      accountId: _idAccount,
      name: _nameController.text,
      categoryName: _categoryName,
      priorityName: _priorityName,
      statusName: _statusName,
      planDate: _tempPlanDate != null ? _tempPlanDate! : "",
    ));
    _loadNotes();
  }

  Future<void> _deleteNote(int id) async {
    await SQLNoteHelper.deleteNote(id);
    _loadNotes();
  }
}
