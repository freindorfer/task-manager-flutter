import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task; // Tarefa opcional para edição

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _isEditing = true;
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (_isEditing) {
        // Editar tarefa existente
        final updatedTask = Task(
          id: widget.task!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _selectedDate,
          isCompleted: widget.task!.isCompleted,
        );
        await Provider.of<TaskProvider>(context, listen: false)
            .updateTask(updatedTask);
      } else {
        // Criar nova tarefa
        final newTask = Task(
          id: DateTime.now().toString(),
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _selectedDate,
        );
        await Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
      }

      // Atualizar lista de tarefas e retornar à tela inicial
      await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Tarefa' : 'Nova Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Título'),
                    controller: _titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira um título';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Descrição'),
                    controller: _descriptionController,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Data de Vencimento: ${_selectedDate.toLocal()}'),
                      TextButton(
                        onPressed: _pickDate,
                        child: Text('Selecionar Data'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: Text('Salvar Tarefa'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: Text('Voltar para Home'),
            ),
          ],
        ),
      ),
    );
  }
}