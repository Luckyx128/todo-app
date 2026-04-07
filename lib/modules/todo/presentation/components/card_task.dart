import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo/modules/todo/data/models/task_model.dart';

class CardTask extends StatefulWidget {
  final int index;
  final TaskModel task;
  final Future<void> Function(TaskModel) deleteTask;
  final Future<void> Function(int, bool) handleCheckTask;

  const CardTask({
    super.key,
    required this.deleteTask,
    required this.task,
    required this.handleCheckTask,
    required this.index,
  });

  @override
  State<CardTask> createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showParticles = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showParticles = false);
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () {
            if (!widget.task.done == true) {
              setState(() => _showParticles = true);
              _controller.forward();
            }
            widget.handleCheckTask(widget.index, widget.task.done);
          },
          child: Card(
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
                    value: widget.task.done,
                    onChanged: (val) {
                      if (val == true) {
                        setState(() => _showParticles = true);
                        _controller.forward();
                      }
                      widget.handleCheckTask(widget.index, widget.task.done);
                    },
                  ),
                  Expanded(
                    child: Text(
                      widget.task.description,
                      style: TextStyle(
                        color: widget.task.done ? Colors.grey : Colors.white,
                        decoration: widget.task.done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: widget.task.done
                            ? Colors.grey
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.deleteTask(widget.task);
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_showParticles)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(painter: ParticlePainter(_controller.value));
              },
            ),
          ),
      ],
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double progress;
  ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final colors = [Color(0xFF1E6F9F), Color(0xFF8284FA), Color(0xFF1E6F9F), Color(0xFF8284FA)];
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.6;

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * pi;
      final radius = maxRadius * progress;
      final opacity = (1 - progress).clamp(0.0, 1.0);

      paint.color = colors[i % colors.length].withValues(alpha:opacity);

      final start = Offset(
        center.dx + cos(angle) * (radius * 0.4),
        center.dy + sin(angle) * (radius * 0.4),
      );
      final end = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter old) => old.progress != progress;
}
