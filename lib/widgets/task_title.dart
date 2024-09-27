import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../screens/task_form_screen.dart';  // Import correto para a tela de formulário


class TaskTitle extends StatelessWidget {
  final Task task;

  TaskTitle(this.task);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(task.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Checkbox para alternar o estado de conclusão
          Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              Provider.of<TaskProvider>(context, listen: false)
                  .toggleTaskCompletion(task.id);
            },
          ),
          // Botão de deletar
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              _confirmDelete(context);
            },
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskFormScreen(task: task),
          ),
        );
      },
    );
  }

  // Função para confirmar a exclusão da tarefa
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(task.id);
              Navigator.of(ctx).pop();
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
