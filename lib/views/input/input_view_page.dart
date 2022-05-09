// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';
// import 'package:numberpicker/numberpicker.dart';
//
// class InputViewPage extends StatelessWidget {
//   final String test = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           toolbarHeight: 56,
//           title: Text(
//               "體溫記錄"),//TODO
//         ),
//         body: SingleChildScrollView(
//           physics: const ClampingScrollPhysics(),
//           child: Container(
//             height: MediaQuery.of(context).size.height -
//                 56 -
//                 MediaQuery.of(context).padding.top,
//             color: Colors.lime.shade100,
//             child: Column(children: [
//               const _MemoWidget(),
//               _DecimalExample(),
//               Container(
//                   height: 50,
//                   color: Colors.green,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Flexible(
//                         child: MaterialButton(
//                             onPressed: () {},
//                             child: const Text(
//                               '儲存',
//                               style: TextStyle(color: Colors.white),
//                             )),
//                       )
//                     ],
//                   ))
//             ]),
//           ),
//         ));
//   }
// }
//
// class _MemoWidget extends StatefulWidget {
//   const _MemoWidget({Key? key}) : super(key: key);
//
//   @override
//   __MemoWidgetState createState() => __MemoWidgetState();
// }
//
// class __MemoWidgetState extends State<_MemoWidget> {
//   final textEditingController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     debugPrint('[Tony] initState');
//     textEditingController.addListener(() {
//       debugPrint('[Tony] input = ${textEditingController.text}');
//     });
//   }
//
//   @override
//   void dispose() {
//     textEditingController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//         child: Padding(
//       padding: const EdgeInsets.all(8),
//       child: TextField(
//         textAlignVertical: TextAlignVertical.center,
//         maxLines: 15,
//         maxLength: 500,
//         decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             labelStyle: TextStyle(fontSize: 18),
//             labelText: '筆記',
//             alignLabelWithHint: true),
//         cursorColor: Colors.green,
//         style: Theme.of(context).textTheme.bodyText1,
//         controller: textEditingController,
//       ),
//     ));
//   }
// }