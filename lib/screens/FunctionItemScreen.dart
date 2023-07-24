import 'package:flutter/material.dart';

import '../helpers/SQLItemHelper.dart';

import '../classes/Item.dart';

class FunctionItemScreen extends StatelessWidget {
  const FunctionItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String functionGet = ModalRoute.of(context)?.settings.arguments as String;
    return MaterialApp(
      home: _HomePage(function: functionGet),
    );
  }
}

class _HomePage extends StatefulWidget {
  final String function;
  const _HomePage({Key? key, required this.function}) : super(key: key);

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  late final String _function;

  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _function = widget.function;
    _refreshJournals();
  }

  Future<void> _refreshJournals() async {
    final data = await SQLHelper.getItems(_function);

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
        builder: (_) => Container(
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
                      if (id == null) {
                        await _addItem();
                      }
                      if (id != null) {
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

  Future<void> _addItem() async {
    await SQLHelper.createItem(Item(
      function: _function,
      name: _titleController.text,
    ));
    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.createItem(Item(
      id: id,
      function: _function,
      name: _titleController.text,
    ));
    _refreshJournals();
  }

  Future<void> _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Delete Success'),
    ));

    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_function + ' Form'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text('Name: ' + _journals[index]['name']),
                  subtitle:
                      Text('Created Date: ' + _journals[index]['createdAt']),
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
