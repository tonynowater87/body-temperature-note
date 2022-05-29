import 'package:flutter/material.dart';

class DateToolbarWidget extends StatelessWidget {
  String title;
  VoidCallback onClickNext;
  VoidCallback onClickPrevious;
  VoidCallback onClickTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Theme.of(context).colorScheme.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
            onPressed: () {
              onClickPrevious.call();
            },
            icon: const Icon(Icons.arrow_circle_left_outlined),
            color: Theme.of(context).iconTheme.color,
          ),
          SizedBox(
            width: 150,
            child: TextButton(
                onPressed: () {
                  onClickTitle.call();
                },
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
          ),
          IconButton(
              padding: EdgeInsets.zero,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
              onPressed: () {
                onClickNext.call();
              },
              icon: Icon(
                Icons.arrow_circle_right_outlined,
                color: Theme.of(context).iconTheme.color,
              )),
        ],
      ),
    );
  }

  DateToolbarWidget({
    Key? key,
    required this.title,
    required this.onClickNext,
    required this.onClickPrevious,
    required this.onClickTitle,
  }) : super(key: key);
}