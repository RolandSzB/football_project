import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

import 'common/strings.dart' as strings;
import 'screens/home_screen.dart';

void main() {
  runApp(const FootballApp());
  Restart();
}

class FootballApp extends StatelessWidget {
  const FootballApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: strings.appTitle,
      home: HomeScreen(),
    );
  }
}
