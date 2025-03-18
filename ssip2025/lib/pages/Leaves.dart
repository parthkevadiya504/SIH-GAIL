import 'package:flutter/material.dart';
class leaves extends StatefulWidget {
  const leaves({super.key});

  @override
  State<leaves> createState() => _leavesState();
}

class _leavesState extends State<leaves> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("This is Leave"),
    );
  }
}
