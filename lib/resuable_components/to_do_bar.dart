import 'package:flutter/material.dart';
import 'package:to_do_list/edit_task_page/edit_task_page.dart';
import '../database/database.dart';
import '../database/to_do_task.dart';

class ToDoBar extends StatefulWidget {
  ToDoBar(
      {required this.db,
      required this.task,
      required this.refreshList,
      super.key});

  Database db;
  ToDoTask task;
  VoidCallback refreshList;

  @override
  State<ToDoBar> createState() => _ToDoBarState();
}

class _ToDoBarState extends State<ToDoBar> {
  bool showDescription = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.task.isDone ? Colors.blue : Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Checkbox(
                    value: widget.task.isDone,
                    onChanged: (bool? value) {
                      widget.db.updateTaskIsDone(widget.task);
                      setState(() {});
                    }),
                Text(widget.task.title),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditTaskPage(
                              db: widget.db,
                              task: widget.task,
                              refreshList: widget.refreshList)));
                    },
                    icon: Icon(Icons.edit)),
                IconButton(
                    onPressed: () {
                      try {
                        widget.db.deleteTask(widget.task);
                        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                            content: Text(
                          "Deleted task successfully",
                          style: TextStyle(color: Colors.lightGreen),
                        )));
                        widget.refreshList();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                            content: Text(
                          "Failed to delete task",
                          style: TextStyle(color: Colors.redAccent),
                        )));
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        showDescription = !showDescription;
                      });
                    },
                    icon: showDescription
                        ? Icon(Icons.arrow_upward)
                        : Icon(Icons.arrow_downward))
              ],
            )
          ]),
          showDescription
              ? Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Priority: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.task.priority)
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "To do by: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.task.todoBy.toString())
                        ],
                      ),
                      Row(children: [
                        Text(
                          "Description: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.task.description,
                        )
                      ]),
                    ],
                  ),
              )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
