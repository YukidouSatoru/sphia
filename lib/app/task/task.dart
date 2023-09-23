import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/task.dart';

class SphiaTask {
  static void addTask(Task task) {
    final taskProvider = GetIt.I.get<TaskProvider>();
    if (isTaskExist(task.name)) {
      cancelTask(task.name);
    }
    logger.i('Adding task: ${task.name}, interval: ${task.interval}');
    task.schedule();
    taskProvider.tasks.add(task);
    taskProvider.updateTask();
  }

  static void cancelTask(String name) {
    if (isTaskExist(name)) {
      logger.i('Canceling task: $name');
      final taskProvider = GetIt.I.get<TaskProvider>();
      taskProvider.tasks.firstWhere((task) => task.name == name).cancel();
      taskProvider.tasks.removeWhere((task) => task.name == name);
      taskProvider.updateTask();
    }
  }

  static bool isTaskExist(String name) {
    final tasks = GetIt.I.get<TaskProvider>().tasks;
    return tasks.any((task) => task.name == name);
  }
}

class Task {
  final String name;
  final Duration interval;
  final Function function;
  Timer? _timer;

  Task(this.name, this.interval, this.function);

  void schedule() {
    _timer = Timer.periodic(interval, (_) {
      logger.i('Running task: $name');
      function();
    });
  }

  void cancel() {
    _timer?.cancel();
  }
}
