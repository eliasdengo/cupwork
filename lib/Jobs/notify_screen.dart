import 'package:cupwork/Widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class notifyScreen extends StatefulWidget {
  const notifyScreen({super.key});

  @override
  State<notifyScreen> createState() => _notifyScreenState();
}

class _notifyScreenState extends State<notifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.deepOrange.shade300, Colors.blueAccent],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: const [0.2, 0.9],
      )),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 4),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Notification Screen'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.deepOrange.shade300, Colors.blueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.2, 0.9],
            )),
          ),
        ),
      ),
    );
  }
}
