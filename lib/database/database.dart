import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/database/to_do_task.dart';

class Database {

  final FirebaseFirestore db;

  Database(this.db);

  Future<List<ToDoTask>> getToDoTasks() async {
    List<ToDoTask> list = List.of({});
    await db.collection("tasks").get().then((event) {
      for (var doc in event.docs) {
        list.add(ToDoTask(
            id: doc.id,
            title: doc.get("title"),
            description: doc.get("description"),
            todoBy: doc.get("todoBy").toDate(),
            priority: doc.get("priority"),
            isDone: doc.get("isDone")));
      }
    });
    return list;
  }

  void addTask(
      String title,
      String description,
      DateTime todoBy,
      String priority,
      ) {
    final task = {
      "title": title,
      "description": description,
      "todoBy": todoBy,
      "priority": priority,
      "isDone": false
    };
    db.collection("tasks").add(task);
  }

  void updateTaskIsDone(ToDoTask task) {
    task.isDone = !task.isDone;
    final document = db.collection("tasks").doc(task.id);
    document.update({"isDone": task.isDone});
  }

  void updateTaskContent(ToDoTask task) {
    final document = db.collection("tasks").doc(task.id);
    document.update({
      "title": task.title,
      "description": task.description,
      "todoBy": task.todoBy,
      "priority": task.priority
    });
  }

  void deleteTask(ToDoTask task) {
    try {
      db.collection("tasks").doc(task.id).delete();
    } catch (e) {
      throw e;
    }
  }

}