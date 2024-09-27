import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../screens/task_form_screen.dart';  
import '../widgets/task_title.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TaskFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<TaskProvider>(context, listen: false).fetchTasks(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<TaskProvider>(
                    builder: (ctx, taskProvider, child) {
                      return ListView.builder(
                        itemCount: taskProvider.tasks.length,
                        itemBuilder: (ctx, i) => TaskTitle(taskProvider.tasks[i]),
                      );
                    },
                  ),
      ),
    );
  }
}
