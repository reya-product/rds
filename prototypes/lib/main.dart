import 'package:flutter/material.dart';
import 'package:rds/rds.dart';

import 'router.dart';

void main() => runApp(const PrototypesApp());

class PrototypesApp extends StatelessWidget {
  const PrototypesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Reya Prototypes',
      debugShowCheckedModeBanner: false,
      theme: RdsBrandThemes.reya.buildThemeData(Brightness.light),
      routerConfig: router,
    );
  }
}
