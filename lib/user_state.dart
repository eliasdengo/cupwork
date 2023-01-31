import 'package:cupwork/Jobs/jobs_screen.dart';
import 'package:cupwork/LoginPage/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, UserSnapshot) {
        if (UserSnapshot.data == null) {
          print('user is not logged in yet');
          return Login();
        } else if (UserSnapshot.hasData) {
          print('user is already logged in yet');
          return JobsScreen();
        } else if (UserSnapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('An error has been occurred. Try again later'),
            ),
          );
        } else if (UserSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: Text('Some thing Went Wrong'),
          ),
        );
      },
    );
  }
}
