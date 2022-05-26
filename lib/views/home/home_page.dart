import 'package:auto_route/auto_route.dart';
import 'package:body_temperature_note/l10n/l10n.dart';
import 'package:body_temperature_note/route/app_router.gr.dart';
import 'package:body_temperature_note/views/home/cubit/home_cubit.dart';
import 'package:body_temperature_note/views/home/date_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
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
              Center(
                  child: Text(
                context.l10n.home_title,
                style: Theme.of(context).textTheme.headlineMedium,
              )),
              IconButton(
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    context.router
                        .push<bool>(SettingsPageRoute(onResult: (needRefresh) {
                      if (needRefresh == true) {
                        context.read<HomeCubit>().refreshRecords();
                      }
                    }));
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.settings_outlined))
            ],
          )),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: DateSelectorWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          final saved = await context.router.push<bool>(
              InputPageRoute(dateString: DateTime.now().toIso8601String()));
          if (saved == true) {
            context.read<HomeCubit>().refreshRecords();
          }
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).iconTheme.color,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
