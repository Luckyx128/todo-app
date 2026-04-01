
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/modules/todo/data/models/task_model.dart';

class CardTask extends StatefulWidget {
  final TaskModel task;
  final Future<void> Function(TaskModel) deleteTask;

  const CardTask({Key? key, required this.deleteTask, required this.task})
    : super(key: key);

  @override
  State<CardTask> createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
  late bool _done;

  @override
  void initState() {
    super.initState();
    _done = widget.task.done;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF262626),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Checkbox(
              activeColor: Color(0xFF1E6F9F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              value: _done,
              onChanged: (val) {
                setState(() {
                  _done = val ?? false;
                });
              },
            ),
            Expanded(
              child: Text(
                widget.task.description,
                style: TextStyle(
                  color: _done ? Colors.grey : Colors.white,
                  decoration: _done
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: _done ? Colors.grey : Colors.transparent,
                ),
              ),
            ),
            IconButton(onPressed: () {widget.deleteTask(widget.task);}, icon: Icon(Icons.delete_outline, color: Colors.grey,))
          ],
        ),
      )
    );
  }
}
