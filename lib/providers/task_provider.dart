import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  final String apiUrl = 'https://35.209.196.164:3000'; // URL do backend

  // Buscar todas as tarefas do backend
  Future<void> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/tasks'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        _tasks = data.map((taskData) => Task.fromJson(taskData)).toList();
        notifyListeners();
      } else {
        throw Exception('Erro ao carregar as tarefas');
      }
    } catch (error) {
      throw Exception('Erro ao conectar com o backend: $error');
    }
  }

  // Adicionar uma nova tarefa
Future<void> addTask(String title, String description, DateTime dueDate) async {
  final url = Uri.parse('$apiUrl/tasks');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      print('Tarefa criada com sucesso: ${response.body}');
    } else {
      print('Erro ao adicionar a tarefa: ${response.statusCode} - ${response.body}');
      throw Exception('Erro ao adicionar a tarefa');
    }
  } catch (error) {
    print('Erro ao conectar com o backend: $error');
    throw Exception('Erro ao conectar com o backend: $error');
  }
}

  // Editar uma tarefa existente
  Future<void> updateTask(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/tasks/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 200) {
        final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
        if (taskIndex != -1) {
          _tasks[taskIndex] = task;
          notifyListeners();
        }
      } else {
        throw Exception('Erro ao editar a tarefa');
      }
    } catch (error) {
      throw Exception('Erro ao conectar com o backend: $error');
    }
  }

  // Deletar uma tarefa
  Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/tasks/$id'));

      if (response.statusCode == 200) {
        _tasks.removeWhere((task) => task.id == id);
        notifyListeners();
      } else {
        throw Exception('Erro ao deletar a tarefa');
      }
    } catch (error) {
      throw Exception('Erro ao conectar com o backend: $error');
    }
  }

  // Alternar o estado de conclusão da tarefa
  Future<void> toggleTaskCompletion(String id) async {
    final task = _tasks.firstWhere((task) => task.id == id);
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
    notifyListeners();
  }
}
