import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/home_bloc/components/body_appbar.dart';
import 'package:todo_app/app/home_bloc/components/progress_bar.dart';
import 'package:todo_app/app/home_bloc/components/tasks_list.dart';
import 'package:todo_app/app/home_bloc/home_bloc.dart';
import 'package:todo_app/app/home_bloc/home_event.dart';
import 'package:todo_app/app/home_bloc/home_state.dart';
import 'package:todo_app/app/home_bloc/tasks_repository.dart';
import 'package:todo_app/app/home_bloc/tasks_status.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);
  final String user;
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<TasksRepository>(
      create: (_) => TasksRepository(uid: user),
      child: const Scaffold(
        appBar: PreferredSize(
            child: SizedBox(height: 100), preferredSize: Size(2, 20)),
        backgroundColor: Colors.blueAccent,
        body: SizedBox(width: double.infinity, child: HomeView()),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksBloc>(
      create: (_) => TasksBloc(taskRepository: context.read<TasksRepository>()),
      child: Column(
        children: const [
          CustomAppbar(),
          Text('Task manager',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          SizedBox(height: 15),
          TasksBodyWidget()
        ],
      ),
    );
  }
}

class TasksBodyWidget extends StatefulWidget {
  const TasksBodyWidget({Key? key}) : super(key: key);

  @override
  State<TasksBodyWidget> createState() => _TasksBodyWidgetState();
}

class _TasksBodyWidgetState extends State<TasksBodyWidget> {
  @override
  void initState() {
    super.initState();
    context.read<TasksBloc>().add(TaskLoadingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: Color(0x05030303), blurRadius: 8)],
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: BlocBuilder<TasksBloc, TaskState>(builder: (context, state) {
          final status = state.status;
          if (status is TaskLoadingSuccess) {
            if (state.tasks.isNotEmpty) {
              return Column(
                children: const [
                  SizedBox(height: 20),
                  WeeklyProgressBar(),
                  TasksList()
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.check_circle_outline,
                    size: 60,
                    color: Colors.black38,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'На сегодня нет задач',
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              );
            }
          } else if (status is TaskLoadingError) {
            final message = status.error.toString();
            if (message ==
                'cannot get a field on a DocumentSnapshotPlatform which does not exist') {
              return const Center(
                child: Text('Нет задач'),
              );
            }
            return const Center(
              child: Text('Произошла ошибка, повторите попытку'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
