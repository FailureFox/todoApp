import 'package:flutter/material.dart';

class AuthTitle extends StatefulWidget {
  const AuthTitle({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<AuthTitle> createState() => _AuthTitleState();
}

class _AuthTitleState extends State<AuthTitle> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  //
  final List<Widget> _widgets = [
    const TitleLine(width: 80),
    const SizedBox(width: 5),
    const TitleLine(width: 18)
  ];

  final List<Widget> _listItems = [];

  void addTrips() {
    Future _ft = Future(() {});
    for (var element in _widgets) {
      _ft = _ft.then(
        (_) => Future.delayed(
          const Duration(milliseconds: 200),
          () {
            _listItems.add(element);
            _listKey.currentState!.insertItem(_listItems.length - 1);
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      addTrips();
    });
  }

  @override
  void dispose() {
    _listKey.currentState != null ? _listKey.currentState!.dispose() : null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(color: Colors.black, fontSize: 19),
        ),
        const SizedBox(height: 10),
        SizedBox(
            width: 130,
            height: 4,
            child: AnimatedList(
              key: _listKey,
              scrollDirection: Axis.horizontal,
              initialItemCount: _listItems.length,
              itemBuilder: (context, index, animation) {
                return _listItems[index];
              },
            )),
      ],
    );
  }
}

class TitleLine extends StatelessWidget {
  const TitleLine({Key? key, required this.width}) : super(key: key);
  final double width;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      curve: Curves.linearToEaseOut,
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double _value, Widget? child) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(20)),
          width: width * _value,
          height: 4,
        );
      },
    );
  }
}
