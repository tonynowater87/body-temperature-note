import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

class InputViewPage extends StatelessWidget {
  final String test = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 56,
          title: Text(
              "體溫記錄"),//TODO
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height -
                56 -
                MediaQuery.of(context).padding.top,
            color: Colors.lime.shade100,
            child: Column(children: [
              const _MemoWidget(),
              _DecimalExample(),
              Container(
                  height: 50,
                  color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: MaterialButton(
                            onPressed: () {},
                            child: const Text(
                              '儲存',
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ))
            ]),
          ),
        ));
  }
}

class _MemoWidget extends StatefulWidget {
  const _MemoWidget({Key? key}) : super(key: key);

  @override
  __MemoWidgetState createState() => __MemoWidgetState();
}

class __MemoWidgetState extends State<_MemoWidget> {
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('[Tony] initState');
    textEditingController.addListener(() {
      debugPrint('[Tony] input = ${textEditingController.text}');
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        maxLines: 15,
        maxLength: 500,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelStyle: TextStyle(fontSize: 18),
            labelText: '筆記',
            alignLabelWithHint: true),
        cursorColor: Colors.green,
        style: Theme.of(context).textTheme.bodyText1,
        controller: textEditingController,
      ),
    ));
  }
}

class _DecimalExample extends StatefulWidget {
  @override
  __DecimalExampleState createState() => __DecimalExampleState();
}

class __DecimalExampleState extends State<_DecimalExample> {
  int _currentDecimal = 36;
  int _currentFloatOne = 0;
  int _currentFloatTwo = 0;
  final f = NumberFormat("##");

  @override
  Widget build(BuildContext context) {
    final TextTheme selectedFloatTextTheme = Theme.of(context).textTheme;
    return WillPopScope(
        onWillPop: () async {
          // You can do some work here.
          // Returning true allows the pop to happen, returning false prevents it.
          debugPrint(
              '[Tony] selected $_currentDecimal, $_currentFloatOne, $_currentFloatTwo');
          return true;
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "體溫",
              style: TextStyle(fontSize: 18),
            ),
            NumberPicker(
              value: _currentDecimal,
              minValue: 35,
              maxValue: 42,
              infiniteLoop: true,
              itemWidth: 55,
              onChanged: (value) => setState(() => _currentDecimal = value),
            ),
            const Text(
              ".",
              style: TextStyle(fontSize: 18),
            ),
            NumberPicker(
              value: _currentFloatOne,
              minValue: 0,
              maxValue: 9,
              itemWidth: 30,
              infiniteLoop: true,
              selectedTextStyle: selectedFloatTextTheme.headline6!
                  .apply(color: Theme.of(context).accentColor),
              onChanged: (value) => setState(() => _currentFloatOne = value),
            ),
            NumberPicker(
              value: _currentFloatTwo,
              minValue: 0,
              maxValue: 9,
              itemWidth: 30,
              infiniteLoop: true,
              selectedTextStyle: selectedFloatTextTheme.headline6!
                  .apply(color: Theme.of(context).accentColor),
              onChanged: (value) => setState(() => _currentFloatTwo = value),
            ),
            const Text(
              "°C",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ));
  }
}
