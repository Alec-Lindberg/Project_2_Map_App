import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/state_visit.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(StateVisitAdapter());
  await Hive.openBox<StateVisit>('stateVisits');

  runApp(const StateTrackerApp());
}

class StateTrackerApp extends StatelessWidget {
  const StateTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '50 State Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomeScreen(),
    );
  }
}


