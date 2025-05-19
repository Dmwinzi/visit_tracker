import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:visits_tracker/Presentation/Screens/Addvisit.dart';

import '../Screens/Homescreen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Homescreen(),
    ),
    GoRoute(
      path: '/addVisit',
      builder: (context, state) => const AddVisitScreen(),
    ),
  ],
);
