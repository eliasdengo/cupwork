import 'package:cupwork/Widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class JobsScreen extends StatefulWidget {
  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Job Screen'),
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


/*
  body: ElevatedButton(
            onPressed: (() {
              _auth.signOut();
              Navigator.canPop(context) ? Navigator.pop(context) : null;
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => UserState()));
            }),
            child: Text('Logout'),
          )*/