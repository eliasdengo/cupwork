import 'package:flutter/material.dart';

class GlobalMethod {
<<<<<<< HEAD
  static void showErrorDialog(
      {required String error, required BuildContext ctx}) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.grey,
                    size: 35,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Error Occured',
                  ),
                )
              ],
            ),
            content: Text(
              error,
              style: const TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontSize: 20),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }
=======
  static void showErrorDialog({required String error, required BuildContext ctx}) 
      {
showDialog(context: ctx, 
builder: (context)
{
  return AlertDialog(
    title: Row(
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.logout,
            color: Colors.grey,
            size: 35,
          ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Error Occured',
            ),
            )
      ],
    ),
    content: Text(
      error,
      style: const TextStyle(
        color: Colors.black,
        fontStyle: FontStyle.italic,
        fontSize: 20
      ),
    ),
    actions: [
      TextButton(
        onPressed: (){
           Navigator.canPop(context) ? Navigator.pop(context):null;
        }, 
        child: const Text(
          'OK',
          style: TextStyle(color: Colors.red),
        ))
    ],
  );
}
)
      }
>>>>>>> 7e8e6c109351751b16eb4caa2a0c7e2844ad50f0
}
