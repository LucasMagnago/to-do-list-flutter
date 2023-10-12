import 'package:to_do_list/models/task.dart';

class TaskRepository {
  final List<Task> _tasks = [];

  Future<void> addTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _tasks.add(task);
  }

  Future<void> editTask(String id, bool done) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _tasks.where((element) => element.id == id).first.done = done;
  }

  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _tasks.removeWhere((element) => element.id == id);
  }

  Future<List<Task>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _tasks;
  }

  Future<List<Task>> getTasksNotDone() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _tasks.where((element) => !element.done).toList();
  }
}
