import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/home_bloc/home_bloc.dart';
import 'package:todo_app/app/home_bloc/home_event.dart';
import 'package:todo_app/app/home_bloc/home_state.dart';
import 'package:todo_app/models/task_model.dart';

class TasksList extends StatelessWidget {
  const TasksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<TasksBloc, TaskState>(builder: (context, state) {
        return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              final bool isToday = context
                  .read<TasksBloc>()
                  .taskRepository
                  .isToday(task.deadLine);
              if (state.taskMode == TasksMode.tasksForToday) {
                if (!task.isCompleted && isToday) {
                  return TaskListItems(
                    tasksModel: state.tasks[index],
                    index: index,
                  );
                }
              } else if (state.taskMode == TasksMode.noCompletedtasks) {
                if (!task.isCompleted &&
                    DateTime.now().difference(task.deadLine).inDays > 0) {
                  return TaskListItems(
                    tasksModel: state.tasks[index],
                    index: index,
                  );
                }
              } else if (state.taskMode == TasksMode.allTasks) {
                return TaskListItems(
                  tasksModel: state.tasks[index],
                  index: index,
                );
              } else if (state.taskMode == TasksMode.completedTasks) {
                if (task.isCompleted) {
                  return TaskListItems(
                    tasksModel: state.tasks[index],
                    index: index,
                  );
                }
              }
              return const SizedBox();
            });
      }),
    );
  }
}

class TaskListItems extends StatelessWidget {
  const TaskListItems({Key? key, required this.tasksModel, required this.index})
      : super(key: key);
  final TaskModel tasksModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TaskState>(builder: (context, state) {
      return Dismissible(
        movementDuration: const Duration(milliseconds: 200),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            context.read<TasksBloc>().add(TaskCompleteEvent(index: index));
          } else if (direction == DismissDirection.startToEnd) {
            context.read<TasksBloc>().add(TaskDeleteEvent(index: index));
          }
        },
        confirmDismiss: (direction) {
          final taskMode = state.taskMode;
          return Future.delayed(const Duration(milliseconds: 1), () {
            if ((taskMode == TasksMode.completedTasks ||
                    taskMode == TasksMode.allTasks) &&
                direction == DismissDirection.endToStart) {
              state.tasks[index].isCompleted == false
                  ? context
                      .read<TasksBloc>()
                      .add(TaskCompleteEvent(index: index))
                  : null;
              return false;
            }
            return true;
          });
        },
        background: const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete,
              color: Colors.redAccent,
              size: 30,
            ),
          ),
        ),
        secondaryBackground: Container(
          color: Colors.transparent,
          child: const Padding(
            padding: EdgeInsets.only(right: 15),
            child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 30,
                )),
          ),
        ),
        key: UniqueKey(),
        child: SizedBox(
          height: 120,
          width: double.infinity,
          child: Row(
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: Text(
                    '${tasksModel.deadLine.hour}:${tasksModel.deadLine.minute}'),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(5, 10, 15, 10),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x2D2965BA),
                            offset: Offset(0, 3),
                            blurRadius: 10),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          tasksModel.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          tasksModel.subtitle,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.blueGrey.withOpacity(0.8),
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            tasksModel.isCompleted
                                ? 'Выполнено'
                                : 'Не выполнено',
                            style: const TextStyle(color: Colors.black38),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
