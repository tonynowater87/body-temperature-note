import 'package:flutter/material.dart';

class DateToolbarWidget extends StatelessWidget {
  String title;
  double? height;
  VoidCallback onClickNext;
  VoidCallback onClickPrevious;
  VoidCallback onClickTitle;
  VoidCallback onClickReturn;

  bool isShownReturnToNowButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 60,
      color: Theme.of(context).colorScheme.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
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
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: TextButton(
                  onPressed: () {
                    //TODO date picker?
                    onClickTitle.call();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      if (isShownReturnToNowButton)
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_return_outlined,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            onClickReturn.call();
                          },
                        )
                    ],
                  )),
            ),
          ),
          IconButton(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
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
    required this.title,
    required this.isShownReturnToNowButton,
    this.height,
    required this.onClickNext,
    required this.onClickPrevious,
    required this.onClickTitle,
    required this.onClickReturn,
  });
}
