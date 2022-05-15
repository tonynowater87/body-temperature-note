import 'package:auto_route/auto_route.dart';
import 'package:body_temperature_note/route/app_router.gr.dart';
import 'package:body_temperature_note/views/home/date_list_widget.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            constraints: const BoxConstraints(),
            onPressed: () {
              //ToDo
            },
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.account_circle_outlined),
          ),
          const Center(child: Text("Title")), //TODO
          IconButton(
              constraints: const BoxConstraints(),
              onPressed: () {
                context.router.push(const SettingsPageRoute());
              },
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.settings_outlined))
        ],
      )),
      body: Container(
        color: Colors.lime.shade100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [
                    const Text('Temperature'),
                    const Icon(Icons.thermostat_outlined),
                    _getTextButton('All')
                  ]),
                  Column(
                    children: [
                      const Text('Graph'),
                      const Icon(Icons.auto_graph_outlined),
                      _getTextButton('On')
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Memo'),
                      const Icon(Icons.remember_me_outlined),
                      _getTextButton('Off')
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              height: 0.0,
              thickness: 0.5,
              indent: 10.0,
              endIndent: 10.0,
              color: Colors.grey,
            ),
            DateSelectorWidget()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.router.push(InputPageRoute(
              dateString: formatDate(DateTime.now(),
                  [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss])));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//TODO make is as StatefulWidget
Widget _getTextButton(String text) {
  return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          minimumSize: const Size(0, 0),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
          backgroundColor: Colors.orange,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ));
}
