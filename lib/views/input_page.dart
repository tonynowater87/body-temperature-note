import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

class InputPage extends StatelessWidget {
  final String? dateString; //yyyy-mm-dd hh:mm:ss

  const InputPage({@PathParam("argument") this.dateString})
      : super(key: null);

  @override
  Widget build(BuildContext context) {
    print('[Tony] InputPage arg: $dateString');
    return Scaffold(
      appBar: AppBar(title: Text('InpputPage'),),
      body: Container(
        child: Text('$dateString'),
      ),
    );
  }
}
