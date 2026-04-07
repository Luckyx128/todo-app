import 'package:todo/modules/todo/domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({required super.uuid, required super.description, required super.done});

  factory TaskModel.fromJson(Map<String,dynamic > json) {
    return TaskModel(uuid: json['uuid'],
        description: json['description'] ,
        done: json['done']
    );
  }
  Map<dynamic, dynamic> toJson() {
    return {
      uuid: uuid,
      description: description,
      done: done
    };
  }

  TaskModel copyWith({
    String? uuid,
    String? description,
    bool? done,
  }) {
    return TaskModel(
      uuid: uuid ?? this.uuid,
      description: description ?? this.description,
      done: done ?? this.done,
    );
  }

}