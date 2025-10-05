import "package:flutter/material.dart";
import 'package:sqflite_project/todo_ui_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TodoUiScrren());
  }
}
