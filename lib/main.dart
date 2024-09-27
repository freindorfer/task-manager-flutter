import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/task_list_screen.dart';
import 'screens/task_form_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // Definir a rota inicial
        initialRoute: '/',
        routes: {
          '/': (context) => TaskListScreen(),  // Rota inicial para listar tarefas
          '/new-task': (context) => TaskFormScreen(),  // Rota para criar nova tarefa
        },
      ),
    );
  }
}