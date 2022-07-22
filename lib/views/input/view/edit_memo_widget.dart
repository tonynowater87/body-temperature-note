import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/views/input/cubit/input_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class EditMemoWidget extends StatefulWidget {
  const EditMemoWidget({Key? key}) : super(key: key);

  @override
  State<EditMemoWidget> createState() => _EditMemoWidgetState();
}

class _EditMemoWidgetState extends State<EditMemoWidget> {
  late TextEditingController textEditingController;
  final _logger = getIt<Logger>();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      String txt = textEditingController.text.toString();
      _logger.d("memo txt = $txt");
      context.read<InputCubit>().updateMemo(txt);
    });
    textEditingController.text =
        (context.read<InputCubit>().state as InputMemoLoaded).memo.memo;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputCubit, InputState>(
      builder: (context, state) {
        if (state is! InputMemoLoaded) {
          throw Error();
        }
        return Container(
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: textEditingController,
          ),
        );
      },
    );
  }
}
