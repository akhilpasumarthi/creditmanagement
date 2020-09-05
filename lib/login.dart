import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
    width: double.infinity,
    decoration: BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors:[
    Colors.deepOrange,
    Colors.amber
    ]
    )
    ),

    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children:<Widget> [
    SizedBox(height:75.0,),
    SizedBox(
    height: 200.0,
    child: Image.asset("images/logo_small.png")
    ),
    SizedBox(
    height: 45,
    ),
    ],


    ),
      )
    );
  }
}
