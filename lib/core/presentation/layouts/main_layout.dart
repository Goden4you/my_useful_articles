import 'package:flutter/material.dart';
import 'package:selfDevelopment/core/presentation/widgets/custom_app_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  MainLayout({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: child,
    );
  }
}
