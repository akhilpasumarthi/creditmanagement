import 'package:creditmanagement/UsersDisplay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3),(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>UsersDisplay()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors:[
              Color(0xff64b5f6),
              Color(0xffFFFFFF),
              Colors.white,
            ]
          )
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget> [
            SizedBox(height: MediaQuery.of(context).size.height*0.08,),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.35,
              child: Image.asset("images/backLogo.png")
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.01,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.2,
            ),
            Text(
              'Credit Management',
              style: TextStyle(
                fontSize: 35,
                color: Color(0xff00897b),
                fontWeight: FontWeight.w600
              ),
            )
          ],
        ),
      )
    );
  }
}
