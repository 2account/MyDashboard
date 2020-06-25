import 'package:flutter/material.dart';
import 'package:dashboard/screens/dashboard.dart';
import 'package:dashboard/screens/notes.dart';
import 'package:dashboard/screens/todos.dart';

void main() {
  runApp(FoodPlan());
}

class FoodPlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Disable the debug banner
      debugShowCheckedModeBanner: false,
      // Set primary colors, and background color
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
        backgroundColor: Color(0xFFf5f6fa),
      ),
      // Set the homepage to the dashboard
      home: Dashboard(title: 'My Dashboard'),
      // Define routes
      routes: {
        'home': (_) => Dashboard(title: "My Dashboard"),
        'notes': (_) => NotesPage(title: "Notes"),
        'todo': (_) => TodoPage(title: "Todo")        
      },
    );
  }
}
