import 'package:flutter/material.dart';
import 'package:mock_prj1/helpers/sql_category_helper.dart';
import 'package:mock_prj1/helpers/sql_priority_helper.dart';
import 'package:mock_prj1/helpers/sql_status_helper.dart';
import '../models/note.dart';
import '../constants/dimension_constant.dart';
import '../constants/text_style_constant.dart';
import '../helpers/sql_account_helper.dart';
import '../helpers/sql_note_helper.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> noteList = [];
  List<Map<String, dynamic>> categoryList = [];
  List<Map<String, dynamic>> priorityList = [];
  List<Map<String, dynamic>> statusList = [];
  final int? _idAccount = SQLAccountHelper.currentAccount['id'];
  String? _categoryName;
  String? _priorityName;
  String? _statusName;
  String? _tempPlanDate;

  // List of categories, priorities, and statuses to be used for dropdowns
  Future<void> _loadcategories() async {
    final categories = await SQLCategoryHelper.getCategories(_idAccount);

    setState(() {
      categoryList = categories;
    });
  }

  Future<void> _loadpriorities() async {
    final priorities = await SQLPriorityHelper.getPriorities(_idAccount);

    setState(() {
      priorityList = priorities;
    });
  }

  Future<void> _loadstatuses() async {
    final statuses = await SQLStatusHelper.getStatuses(_idAccount);

    setState(() {
      statusList = statuses;
    });
  }

  //Load data notes.
  Future<void> _loadNotes() async {
    final data = await SQLNoteHelper.getNotes(accountId: _idAccount);

    setState(() {
      noteList = data;
    });
  }

  // DropdownButton onChanged callbacks to update the selected values
  void _onCategoryChanged(Map<String, dynamic>? value) {
    setState(() {
      _categoryName = value?['name'];
    });
  }

  void _onPriorityChanged(Map<String, dynamic>? value) {
    setState(() {
      _priorityName = value?['name'];
    });
  }

  void _onStatusChanged(Map<String, dynamic>? value) {
    setState(() {
      _statusName = value?['name'];
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
      createdAt: DateTime.now().toIso8601String(),
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
    _onClearNote();
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
      _loadcategories();
      _loadpriorities();
      _loadstatuses();
    }
  }

  //validate
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required.';
    }
    return null; // Hợp lệ
  }

  String? _validateCategory(int? value) {
    if (value == null) {
      return 'Category is required.';
    }
    return null; // Hợp lệ
  }

  String? _validatePriority(int? value) {
    if (value == null) {
      return 'Priority is required.';
    }
    return null; // Hợp lệ
  }

  String? _validateStatus(int? value) {
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
          title: Text(id == null ? "Add Note" : "Update Note"),
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
                  DropdownButtonFormField<int>(
                    value: _categoryName != null
                        ? categoryList.firstWhere(
                            (category) => category['name'] == _categoryName,
                            orElse: () => categoryList.first,
                          )['id']
                        : null,
                    items: categoryList.map((category) {
                      return DropdownMenuItem<int>(
                        value: category['id'],
                        child: Text(category['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _onCategoryChanged(categoryList
                          .firstWhere((category) => category['id'] == value));
                    },
                    decoration: const InputDecoration(labelText: "Category"),
                    validator: (value) {
                      return _validateCategory(value);
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: _priorityName != null
                        ? priorityList.firstWhere(
                            (priority) => priority['name'] == _priorityName,
                            orElse: () => priorityList.first,
                          )['id']
                        : null,
                    items: priorityList.map((priority) {
                      return DropdownMenuItem<int>(
                        value: priority['id'],
                        child: Text(priority['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _onPriorityChanged(priorityList
                          .firstWhere((priority) => priority['id'] == value));
                    },
                    decoration: const InputDecoration(labelText: "Priority"),
                    validator: (value) {
                      return _validatePriority(value);
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: _statusName != null
                        ? statusList.firstWhere(
                            (status) => status['name'] == _statusName,
                            orElse: () => statusList.first,
                          )['id']
                        : null,
                    items: statusList.map((status) {
                      return DropdownMenuItem<int>(
                        value: status['id'],
                        child: Text(status['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _onStatusChanged(statusList
                          .firstWhere((status) => status['id'] == value));
                    },
                    decoration: const InputDecoration(labelText: "Status"),
                    validator: (value) {
                      return _validateStatus(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  _SelectedDateWidget(
                    initialDate: _tempPlanDate,
                    onDateChanged: (selectedDate) {
                      _tempPlanDate = selectedDate;
                    },
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
      body: ListView.builder(
        itemCount: noteList.length,
        itemBuilder: (context, index) {
          final note = noteList[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
            margin: cardMargin,
            color: Colors.orange[200],
            child: ListTile(
              title: Text(
                note['name'] ?? '',
                style: cardTitleTextStyle,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category: ${note['categoryName'] ?? ''}'),
                  Text('Priority: ${note['priorityName'] ?? ''}'),
                  Text('Status: ${note['statusName'] ?? ''}'),
                  Text(
                      'Plan Date: ${note['planDate'] != null ? note['planDate']!.toString().substring(0, 10) : ''}'),
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
      createdAt: DateTime.now().toIso8601String(),
    ));
    _loadNotes();
  }

  Future<void> _deleteNote(int id) async {
    await SQLNoteHelper.deleteNote(id);
    _loadNotes();
  }
}

class _SelectedDateWidget extends StatefulWidget {
  final String? initialDate;
  final Function(String) onDateChanged;

  const _SelectedDateWidget({
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  _SelectedDateWidgetState createState() => _SelectedDateWidgetState();
}

class _SelectedDateWidgetState extends State<_SelectedDateWidget> {
  late String _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? '';
  }

  void _updateSelectedDate(String selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
      widget.onDateChanged(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            // Show DateTimePicker and update _selectedDate
            String? pickedDate = await _showDatePicker(context, _selectedDate);
            if (pickedDate != null) {
              _updateSelectedDate(pickedDate);
            }
          },
          child: const Text("Pick Plan Date"),
        ),
        Text(
          _selectedDate.isNotEmpty
              ? "Selected Date: ${_selectedDate.substring(0, 10)}"
              : "................................",
        ),
      ],
    );
  }
}

Future<String?> _showDatePicker(
    BuildContext context, String initialDate) async {
  DateTime currentDate =
      initialDate.isNotEmpty ? DateTime.parse(initialDate) : DateTime.now();

  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    return pickedDate.toIso8601String();
  }
  return null;
}
