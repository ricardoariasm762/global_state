import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_state/controllers/task_controller.dart';
import 'package:global_state/models/task.dart';

class HomeScreen extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());

  HomeScreen({super.key});

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'alta':
        return Colors.red;
      case 'media':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Tareas'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.tasks.isEmpty) {
          return const Center(
            child: Text(
              "No hay tareas registradas",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.tasks.length,
          itemBuilder: (context, index) {
            final task = controller.tasks[index];

            return Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(
                  task.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(task.description),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text("Estado: "),
                        DropdownButton<String>(
                          value: task.status,
                          items: const [
                            DropdownMenuItem(
                                value: "pendiente",
                                child: Text("Pendiente")),
                            DropdownMenuItem(
                                value: "proceso",
                                child: Text("En proceso")),
                            DropdownMenuItem(
                                value: "finalizada",
                                child: Text("Finalizada")),
                          ],
                          onChanged: (value) {
                            controller.updateStatus(
                                task.id, value!);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color:
                            _priorityColor(task.priority),
                        shape: BoxShape.circle,
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          controller.deleteTask(task.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String priority = "media";

    Get.defaultDialog(
      title: "Nueva Tarea",
      content: Column(
        children: [
          TextField(
            controller: titleController,
            decoration:
                const InputDecoration(labelText: "Título"),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
                labelText: "Descripción"),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: priority,
            items: const [
              DropdownMenuItem(
                  value: "baja", child: Text("Baja")),
              DropdownMenuItem(
                  value: "media", child: Text("Media")),
              DropdownMenuItem(
                  value: "alta", child: Text("Alta")),
            ],
            onChanged: (value) {
              priority = value!;
            },
            decoration:
                const InputDecoration(labelText: "Prioridad"),
          ),
        ],
      ),
      textConfirm: "Guardar",
      textCancel: "Cancelar",
      onConfirm: () {
        final newTask = Task(
          id: DateTime.now().millisecondsSinceEpoch,
          title: titleController.text,
          description: descriptionController.text,
          status: "pendiente",
          priority: priority,
        );

        controller.addTask(newTask);
        Get.back();
      },
    );
  }
}