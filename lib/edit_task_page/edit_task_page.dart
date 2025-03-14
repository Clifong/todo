import 'package:flutter/material.dart';
import 'package:to_do_list/database/database.dart';
import '../database/to_do_task.dart';

class EditTaskPage extends StatefulWidget {
  EditTaskPage({required this.db, required this.task, required this.refreshList, super.key});

  Database db;
  final ToDoTask task;
  final VoidCallback refreshList;

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late final TextEditingController titleField;
  late final TextEditingController descriptionField;

  @override
  void initState() {
    super.initState();
    titleField = TextEditingController();
    descriptionField = TextEditingController();
    titleField.text = widget.task.title;
    descriptionField.text = widget.task.description;
  }

  @override
  void dispose() {
    titleField.dispose();
    descriptionField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit task",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Title:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      TextField(
                        controller: titleField,
                        decoration: InputDecoration(hintText: "Enter a title"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Description:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      TextField(
                        controller: descriptionField,
                        decoration:
                        InputDecoration(hintText: "Enter a description"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Due by:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      SizedBox(height: 15),
                      InputDatePickerFormField(
                        initialDate: widget.task.todoBy,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(9999),
                        onDateSubmitted: (date) {
                          widget.task.todoBy = date;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Priority:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownMenu(
                          initialSelection: widget.task.priority,
                          dropdownMenuEntries: List.of({
                            DropdownMenuEntry(value: "High", label: "High"),
                            DropdownMenuEntry(value: "Medium", label: "Medium"),
                            DropdownMenuEntry(value: "Low", label: "Low"),
                          }),
                          onSelected: (String? value) {
                            widget.task.priority = value!;
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              TextButton(
                  onPressed: () {
                    if (titleField.text != "" && descriptionField.text != "") {
                      widget.task.updateInformation(
                          titleField.text,
                          descriptionField.text,
                      );
                      widget.db.updateTaskContent(widget.task);
                      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: Text(
                            "Successfully edited task!",
                            style: TextStyle(color: Colors.lightGreenAccent),
                          )));
                      widget.refreshList();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: Text(
                            "One of the fields is empty!",
                            style: TextStyle(color: Colors.redAccent),
                          )));
                    }
                  },
                  child: Text("Edit task"))
            ],
          ),
        ),
      ),
    );
  }
}
