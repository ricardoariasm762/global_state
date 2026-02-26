import 'package:get/get.dart';
import 'package:global_state/models/task.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;

  void addTask(Task task) {
    tasks.add(task);
  }

  void deleteTask(int id) {
    tasks.removeWhere((task) => task.id == id);
  }

  void updateStatus(int id, String newStatus) {
    var task = tasks.firstWhere((t) => t.id == id);
    task.status = newStatus;
    tasks.refresh();
  }
}