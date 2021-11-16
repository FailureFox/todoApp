import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/home_bloc/home_bloc.dart';
import 'package:todo_app/app/home_bloc/home_event.dart';
import 'package:todo_app/app/home_bloc/home_state.dart';

class WeeklyProgressBar extends StatelessWidget {
  const WeeklyProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blueGrey.withOpacity(0.2), width: 2),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const ProgressIndicator(),
          BlocBuilder<TasksBloc, TaskState>(builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 3),
                const Text('Прогресс за неделю'),
                const Spacer(flex: 2),
                Text(
                    '${state.completedTasksLenght()}/${state.tasksLenght} за неделю'),
                const Spacer(flex: 3),
              ],
            );
          }),
          const TaskModeSelection()
        ],
      ),
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TaskState>(builder: (context, state) {
      return SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
                height: 70,
                width: 70,
                child: TweenAnimationBuilder<double>(
                  tween:
                      Tween<double>(begin: 0.0, end: state.getprogress() / 100),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, value, _) => CircularProgressIndicator(
                    strokeWidth: 8,
                    color: Colors.blueAccent,
                    value: value,
                    backgroundColor: Colors.blueGrey.withOpacity(0.2),
                  ),
                )),
            state.getprogress() == 100
                ? const Center(
                    child: Icon(
                    Icons.check,
                    color: Colors.blueAccent,
                    size: 30,
                  ))
                : Text(state.getprogress().toStringAsFixed(0) + '%')
          ],
        ),
      );
    });
  }
}

class TaskModeSelection extends StatelessWidget {
  const TaskModeSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: const EdgeInsets.all(0),
      onSelected: (TasksMode result) {
        context.read<TasksBloc>().add(TaskModeChangeEvent(tasksMode: result));
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<TasksMode>>[
        const PopupMenuItem<TasksMode>(
          value: TasksMode.allTasks,
          child: Text('Все', style: TextStyle(color: Colors.blueGrey)),
        ),
        const PopupMenuItem<TasksMode>(
          value: TasksMode.tasksForToday,
          child: Text('Задачи на сегодня',
              style: TextStyle(color: Colors.blueGrey)),
        ),
        const PopupMenuItem<TasksMode>(
          value: TasksMode.noCompletedtasks,
          child: Text('Пропущенные задачи',
              style: TextStyle(color: Colors.blueGrey)),
        ),
        const PopupMenuItem<TasksMode>(
          value: TasksMode.completedTasks,
          child: Text('Выполненные задачи',
              style: TextStyle(color: Colors.blueGrey)),
        ),
      ],
    );
  }
}
