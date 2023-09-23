import 'package:flutter/material.dart';
import 'package:sphia/app/task/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];

  void updateTask() {
    notifyListeners();
  }
}
