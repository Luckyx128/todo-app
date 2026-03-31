import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardTask extends StatefulWidget {
  final String descricao;
  final bool done;

  const CardTask({Key? key, required this.descricao, this.done = false})
    : super(key: key);

  @override
  State<CardTask> createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
  late bool _done;

  @override
  void initState() {
    super.initState();
    _done = widget.done;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.descricao),
        trailing: Checkbox(
          value: _done,
          onChanged: (val) {
            setState(() {
              _done = val ?? false;
            });
          },
        ),
      ),
    );
  }
}
