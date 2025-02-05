import 'package:expense_app_tracker/HomeScreen.dart';
import 'package:expense_app_tracker/Shared/Cubit.dart';
import 'package:expense_app_tracker/Shared/States.dart';
import 'package:expense_app_tracker/Shared/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          home:MyApp(),
          debugShowCheckedModeBanner: false,
        ),
      )));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
