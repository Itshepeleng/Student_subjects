// =============================================================
// MAIN.DART: The entry point - connects everything
//
// RULES:
// 1. Wrap the app with ChangeNotifierProvider
// 2. Provider creates the ViewModel ONCE and makes it available
// 3. Use create: NOT value: for objects that should live
// =============================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/student_viewmodel.dart';
import 'views/student_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Info App',
      theme: ThemeData(primarySwatch: Colors.blue),
      // ChangeNotifierProvider - the CONNECTOR
      // It creates the ViewModel and makes it available to all widgets below
      home: ChangeNotifierProvider(
        // create: Creates the ViewModel ONCE when app starts
        // Important: Use create: NOT value: for objects that should live
        create: (context) => StudentViewModel(),
        // child: The first screen that can access this ViewModel
        child: const StudentView(),
      ),
    );
  }
}
