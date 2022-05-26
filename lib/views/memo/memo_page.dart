import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/views/memo/cubit/memo_cubit.dart';
import 'package:body_temperature_note/views/memo/cubit/memo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class MemoPage extends StatefulWidget {
  late String dateString;

  MemoPage({Key? key, required this.dateString}) : super(key: key);

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final _logger = getIt<Logger>();
  TextEditingController textEditingController = TextEditingController();
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();
    context.read<MemoCubit>().load(widget.dateString);
    textEditingController.addListener(() {
      context.read<MemoCubit>().updateText(textEditingController.text);
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoCubit, MemoState>(
      builder: (buildContext, state) {
        if (state is MemoLoadedState) {
          return AlertDialog(
            title: Text(state.formattedDateString),
            content: TextField(
                focusNode: myFocusNode,
                controller: textEditingController..text = state.memo.memo),
            actions: <Widget>[
              TextButton(
                child: Text('Save'),
                onPressed: () async {
                  await context.read<MemoCubit>().save();
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        } else {
          return const AlertDialog(content: CircularProgressIndicator());
        }
      },
    );
  }
}
