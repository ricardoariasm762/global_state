class Task {
  int id;
  String title;
  String description;
  String status; // pendiente, proceso, finalizada
  String priority; // baja, media, alta

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
  });
}