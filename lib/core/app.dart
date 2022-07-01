import 'package:flutter/material.dart';
import 'package:status_bluetooth/config/routes.dart';
import 'package:status_bluetooth/features/interface/views/login_view.dart';
import 'package:status_bluetooth/features/interface/views/status_view.dart';

class StatusApp extends StatefulWidget {
  const StatusApp({Key? key}) : super(key: key);

  @override
  State<StatusApp> createState() => _StatusAppState();
}

class _StatusAppState extends State<StatusApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.statusRoute,
      routes: {
        AppRoutes.loginRoute: (context) => const LoginView(),
        AppRoutes.statusRoute: (context) => StatusView(),
      },
    );
  }
}
