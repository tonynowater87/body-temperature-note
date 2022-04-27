import 'package:auto_route/annotations.dart';
import 'package:body_temperature_note/main.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class InputPage extends StatelessWidget {

  final String? dateString; //yyyy-mm-dd hh:mm:ss
  final logger = getIt.get<Logger>();

  InputPage({@PathParam("argument") this.dateString})
      : super(key: null);

  @override
  Widget build(BuildContext context) {
    logger.d('[Tony] InputPage arg: $dateString');
    return Scaffold(
      appBar: AppBar(title: Text('InpputPage'),),
      body: Container(
        child: Text('$dateString'),
      ),
    );
  }
}
