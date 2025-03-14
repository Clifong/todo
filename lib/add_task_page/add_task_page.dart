import 'package:flutter/material.dart';

import '../database/database.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({required this.db, required this.refreshList, super.key});

  final Database db;
  final VoidCallback refreshList;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late final TextEditingController titleField;
  late final TextEditingController descriptionField;
  String priorityValue = "Low";
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    titleField = TextEditingController();
    descriptionField = TextEditingController();
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
          "Task to add",
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
                        initialDate: date,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(9999),
                        onDateSubmitted: (date) {
                          this.date = date;
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
                          initialSelection: priorityValue,
                          dropdownMenuEntries: List.of({
                            DropdownMenuEntry(value: "High", label: "High"),
                            DropdownMenuEntry(value: "Medium", label: "Medium"),
                            DropdownMenuEntry(value: "Low", label: "Low"),
                          }),
                          onSelected: (String? value) {
                            priorityValue = value!;
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
                      widget.db.addTask(
                          titleField.text,
                          descriptionField.text,
                          date,
                          priorityValue
                      );
                      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: Text(
                        "Successfully added task!",
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
                  child: Text("Add task"))
            ],
          ),
        ),
      ),
    );
  }
}
