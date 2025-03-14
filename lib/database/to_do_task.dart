class ToDoTask {
  final String id;
  String title;
  String description;
  String priority;
  DateTime todoBy;
  bool isDone;

  void updateInformation(String title, String description) {
    this.title = title;
    this.description = description;
  }

  ToDoTask({required this.id, required this.title, required this.description, required this.todoBy, required this.priority, required this.isDone});
}