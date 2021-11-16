import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/home_bloc/home_bloc.dart';
import 'package:todo_app/app/home_bloc/tasks_repository.dart';
import 'package:todo_app/app/task_add_bloc/task_add_view.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext mycontext) {
    final uid = mycontext.read<TasksBloc>().taskRepository.uid;
    final TasksRepository tasksRepository =
        mycontext.watch<TasksBloc>().taskRepository;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          SizedBox(
            height: 50,
            width: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 9,
                    primary: Colors.white,
                    shadowColor: Colors.white24,
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17))),
                onPressed: () {
                  Navigator.push(
                      mycontext,
                      MaterialPageRoute(
                          builder: (context) => TaskAddPage(
                                uid: uid,
                                homeContext: mycontext,
                              )));
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.blueAccent,
                )),
          ),
        ],
      ),
    );
  }
}
