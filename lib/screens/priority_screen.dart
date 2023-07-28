import 'package:flutter/material.dart';
import 'package:mock_prj1/models/priority.dart';
import 'package:mock_prj1/helpers/sql_priority_helper.dart';

import '../constants/dimension_constant.dart';
import '../constants/text_style_constant.dart';
import '../helpers/sql_account_helper.dart';

class PriorityItemScreen extends StatelessWidget {
  const PriorityItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  final int _currentUserId = SQLAccountHelper.currentAccount['id'];

  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  Future<void> _refreshJournals() async {
    final data = await SQLPriorityHelper.getPriorities(_currentUserId);

    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  final TextEditingController _titleController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['name'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (context) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null &&
                          await SQLPriorityHelper.checkValidPriority(
                              _titleController.text)) {
                        await _addItem();
                      }
                      if (id != null &&
                          await SQLPriorityHelper.checkValidPriority(
                              _titleController.text)) {
                        await _updateItem(id);
                      }

                      _titleController.text = '';

                      if (!mounted) return;

                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Create New' : 'Update'),
                  )
                ],
              ),
            ));
  }

  void snackBarDisplay(String? action) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action Success'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _addItem() async {
    await SQLPriorityHelper.createPriority(Priority(
      userId: _currentUserId,
      name: _titleController.text,
    ));

    snackBarDisplay("Add");

    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await SQLPriorityHelper.updatePriority(
      Priority(
          id: id,
          userId: _currentUserId,
          name: _titleController.text,
          createdAt: DateTime.now().toString()),
    );

    snackBarDisplay('Update');

    _refreshJournals();
  }

  Future<void> _deleteItem(int id) async {
    await SQLPriorityHelper.deletePriority(id);

    snackBarDisplay("Delete");

    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                shape:
                    RoundedRectangleBorder(borderRadius: defaultBorderRadius),
                color: Colors.orange[200],
                margin: cardMargin,
                child: ListTile(
                  title: Text(
                    _journals[index]['name'],
                    style: cardTitleTextStyle,
                  ),
                  subtitle: Text(
                      'Created Date: ${_journals[index]['createdAt'].toString().substring(0, 10)}'),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showForm(_journals[index]['id']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteItem(_journals[index]['id']),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
