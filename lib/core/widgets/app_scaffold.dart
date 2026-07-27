import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
    this.showBackButton = false,
    this.padding = const EdgeInsets.all(20),
  });

  final String title;
  final Widget body;

  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? bottomNavigationBar;

  final bool showBackButton;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,

      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: showBackButton,
        title: Text(title),
        actions: actions,
      ),

      floatingActionButton: floatingActionButton,

      bottomNavigationBar: bottomNavigationBar,

      body: SafeArea(
        child: Padding(
          padding: padding,
          child: body,
        ),
      ),
    );
  }
}