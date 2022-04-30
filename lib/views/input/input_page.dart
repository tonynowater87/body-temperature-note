import 'package:auto_route/annotations.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/views/input/cubit/input_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class InputPage extends StatefulWidget {
  //yyyy-mm-dd hh:nn:ss
  late String dateString;

  InputPage({@PathParam("argument") required this.dateString})
      : super(key: null);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final logger = getIt.get<Logger>();
  late InputCubit _inputCubit;

  _InputPageState();

  @override
  void initState() {
    super.initState();
    _inputCubit = context.read<InputCubit>();
    _inputCubit.initState(widget.dateString);
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[Tony] InputPage arg: ${widget.dateString}');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dateString),
      ),
      body: BlocBuilder<InputCubit, InputState>(
        builder: (context, state) {
          if (state is InputInitial) {
            return const CircularProgressIndicator();
          } else if (state is InputLoading) {
            return const CircularProgressIndicator();
          } else if (state is InputLoaded) {
            return const InputContainer();
          } else {
            throw Error();
          }
        },
      ),
    );
  }
}

class InputContainer extends StatelessWidget {
  const InputContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputCubit, InputState>(
      builder: (context, state) {
        return Container();
      },
    );
  }
}
