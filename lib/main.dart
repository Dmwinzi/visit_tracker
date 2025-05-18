import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:visits_tracker/DI/Locator.dart';
import 'package:visits_tracker/Presentation/Homescreen.dart';

import 'Presentation/Routing/Router.dart';

void main() async{
  await dotenv.load();
  await Setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

