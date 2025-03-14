import 'package:flutter/material.dart';
import 'package:to_do_list/add_task_page/add_task_page.dart';
import 'package:to_do_list/resuable_components/to_do_bar.dart';

import 'database/database.dart';

class MainPage extends StatefulWidget {
  MainPage({required this.db, super.key});

  Database db;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  void refreshList() {
    setState(() {
      widget.db.getToDoTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          widget.db.getToDoTasks();
        });
        return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "To do list",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                      AddTaskPage(
                        db: widget.db,
                        refreshList: refreshList
                      )
                    )
                  );
                },
                child: Text(
                  "Add todo list",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: FutureBuilder(
            future: widget.db.getToDoTasks(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ToDoBar(
                        db: widget.db,
                        task: snapshot.data![index],
                        refreshList: refreshList,
                      );
                    });
              } else {
                return Center(child: Text("No data at the moment."));
              }
            }),
      ),
    );
  }
}
