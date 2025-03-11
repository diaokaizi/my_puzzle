import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';
import 'models/puzzle_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PuzzleModel(),
      child: MaterialApp(
        title: 'MyPuzzle',
        theme: AppTheme.themeData,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
} 