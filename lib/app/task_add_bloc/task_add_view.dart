import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/home_bloc/home_bloc.dart';
import 'package:todo_app/app/home_bloc/home_event.dart';
import 'package:todo_app/app/home_bloc/tasks_repository.dart';
import 'package:todo_app/app/task_add_bloc/task_add_bloc.dart';
import 'package:todo_app/app/task_add_bloc/task_add_event.dart';
import 'package:todo_app/app/task_add_bloc/task_add_state.dart';
import 'package:todo_app/models/task_model.dart';

class TaskAddPage extends StatelessWidget {
  const TaskAddPage({Key? key, required this.uid, required this.homeContext})
      : super(key: key);
  final String uid;
  final BuildContext homeContext;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<TasksRepository>(
      create: (_) => TasksRepository(uid: uid),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              homeContext.read<TasksBloc>().add(TaskLoadingEvent());
            },
            icon:
                const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
              child: TasksAddForm(
                homeContext: homeContext,
              )),
        ),
      ),
    );
  }
}

class TasksAddForm extends StatelessWidget {
  TasksAddForm({Key? key, required this.homeContext}) : super(key: key);
  final BuildContext homeContext;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<TaskAddBloc>(
      create: (_) =>
          TaskAddBloc(taskRepository: context.read<TasksRepository>()),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              ' Название задачи',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            const TitleForm(),
            const Spacer(),
            const Text(' Описание задачи',
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 10),
            const SubTitleForm(),
            const Spacer(),
            const Text(' Выберите дату',
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 10),
            const DateTimeForm(),
            const Spacer(flex: 6),
            AddTaskButton(formKey: formKey, homeContext: homeContext),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

class AddTaskButton extends StatelessWidget {
  const AddTaskButton(
      {Key? key, required this.formKey, required this.homeContext})
      : super(key: key);
  final GlobalKey<FormState> formKey;
  final BuildContext homeContext;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: BlocBuilder<TaskAddBloc, TaskAddState>(builder: (context, sate) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                shadowColor: const Color(0x745B7FFF),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                context.read<TaskAddBloc>().add(TaskAddEvent());
                Navigator.pop(context);
                final taskmodel = context.read<TaskAddBloc>().state;
                final List<TaskModel> tasks =
                    homeContext.read<TasksBloc>().state.tasks;
                tasks.add(TaskModel(
                    title: taskmodel.title,
                    isCompleted: false,
                    subtitle: taskmodel.subTitle,
                    deadLine: taskmodel.dateTime,
                    addDate: DateTime.now()));

                homeContext
                    .read<TasksBloc>()
                    .add(TaskChangedEvent(tasks: tasks));
              }
            },
            child: const Text('Добавить задачу',
                style: TextStyle(fontSize: 16.5)));
      }),
    );
  }
}

class DateTimeForm extends StatefulWidget {
  const DateTimeForm({Key? key}) : super(key: key);

  @override
  State<DateTimeForm> createState() => _DateTimeFormState();
}

class _DateTimeFormState extends State<DateTimeForm> {
  DateTime dateTime = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  pickDate() async {
    dateTime = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2101)) ??
        dateTime;
    time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now()) ??
            time;
    if (dateTime != DateTime.now()) {
      DateTime(
          dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);

      context.read<TaskAddBloc>().add(TaskDateTimeChanged(dateTime: dateTime));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: pickDate,
        child: Container(
            padding: const EdgeInsets.all(21),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1.2, color: const Color(0x2A21213E))),
            child: Text(
                '${dateTime.day}.${dateTime.month}.${dateTime.year}г - ${time.hour}:${time.minute}')));
  }
}

class TitleForm extends StatelessWidget {
  const TitleForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value == '') {
          return 'Введите описание задачи';
        }
        return null;
      },
      onChanged: (value) {
        context.read<TaskAddBloc>().add(TaskTitleChangeEvent(title: value));
      },
      focusNode: FocusNode(canRequestFocus: false),
      decoration: const InputDecoration(
        hintText: 'Введите название задачи',
        focusedBorder: Decoration.decoration,
        border: Decoration.decoration,
        enabledBorder: Decoration.decoration,
      ),
    );
  }
}

class SubTitleForm extends StatelessWidget {
  const SubTitleForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value == '') {
          return 'Введите описание задачи';
        }
        return null;
      },
      onChanged: (value) {
        context
            .read<TaskAddBloc>()
            .add(TaskSubTitleChangeEvent(subtitle: value));
      },
      maxLines: 4,
      decoration: const InputDecoration(
          hintText: 'Введите описание задачи',
          focusedBorder: Decoration.decoration,
          border: Decoration.decoration,
          enabledBorder: Decoration.decoration),
    );
  }
}

class Decoration {
  static const decoration = OutlineInputBorder(
    borderSide: BorderSide(width: 1.2, color: Color(0x2A21213E)),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  );
}
