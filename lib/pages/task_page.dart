import 'package:flutter/material.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/repositories/task_repository.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TaskRepository _taskRepository = TaskRepository();
  final TextEditingController _descriptionController = TextEditingController();
  List<Task> _lstTask = <Task>[];
  bool _sort = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    if (_sort) {
      _lstTask = await _taskRepository.getTasksNotDone();
    } else {
      _lstTask = await _taskRepository.getTasks();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To-Do List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _lstTask.isEmpty && _sort == false
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 100, child: Icon(Icons.list_alt)),
                  Text('Empty list')
                ],
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _sort = !_sort;
                          loadData();
                        },
                        child: _sort
                            ? const Icon(Icons.short_text_rounded)
                            : const Icon(Icons.sort_rounded),
                      ),
                      Text(_sort ? 'Not done yet' : 'All'),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _lstTask.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: Key(_lstTask[index].id),
                            onDismissed: (DismissDirection direction) async {
                              await _taskRepository
                                  .deleteTask(_lstTask[index].id);
                              loadData();
                            },
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              leading: const Icon(Icons.task),
                              title: Text(
                                _lstTask[index].description,
                                style: TextStyle(
                                    decoration: _lstTask[index].done
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              ),
                              trailing: Checkbox(
                                onChanged: (value) async {
                                  await _taskRepository.editTask(
                                      _lstTask[index].id.toString(), value!);
                                  loadData();
                                },
                                value: _lstTask[index].done,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext bc) {
                return AlertDialog(
                  title: const Text('Create new task'),
                  content: TextField(
                    controller: _descriptionController,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _descriptionController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        String description = _descriptionController.text;

                        if (description.isNotEmpty) {
                          await _taskRepository
                              .addTask(Task(description, false));
                          _descriptionController.clear();
                          Navigator.pop(context);
                          setState(() {});
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
