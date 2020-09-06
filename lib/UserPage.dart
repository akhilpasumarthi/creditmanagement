import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class UserPage extends StatefulWidget {
  UserPage({this.credit,this.name,this.people,this.email});
  final List<String> people;
  final String name,email;
  final int credit;
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<String> names = [];
  String name;
  int credit = 0;
  int userCredits;
  Firestore firestore = Firestore.instance;
  TextEditingController textEditingController = TextEditingController();
  int otherCredit;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
  }

  void variables(){
    for(String person in widget.people){
      names.add(person);
    }
    names.remove(widget.name);
    name = names[0];
    userCredits = widget.credit;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    variables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height*0.1,
          ),
          Center(
            child: CircleAvatar(
              backgroundColor: Color(0xff64b5f6),
              radius: 60,
              child: Icon(
                FontAwesomeIcons.userAlt,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.03,
          ),
          Center(
            child: Text(
              widget.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 34,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.01,
          ),
          Center(
            child: Text(
              widget.email,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.05,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.08),
            child: Row(
              children: <Widget>[
                Text('Your Credits: ', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.03,
                ),
                Center(
                    child: Text(userCredits.toString(), style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),),
                )
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.05,),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xff90caf9),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              width: MediaQuery.of(context).size.width*0.6,
              child: DropdownButton(
                isExpanded: true,
                dropdownColor: Color(0xff90caf9),
                value: name,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                icon: Icon(Icons.keyboard_arrow_down),
                elevation: 10,
                onChanged: (String value){
                  setState(() {
                    name = value;
                  });
                },
                items: names.map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem(
                    value: value,
                    child: Center(child: Text(value)),
                  );
                }).toList(),
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height*0.05,
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.08),
            child: Row(
              children: <Widget>[
                Text('Enter Credits: ', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.03,
                ),
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                    onChanged: (val){
                      setState(() {
                        credit = int.parse(val);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.1,
          ),

          Center(
            child: GestureDetector(
              onTap: () async{
                if(widget.credit !=0 && widget.credit-credit>0){
                  textEditingController.clear();
                  DocumentSnapshot snapshot = await firestore.collection('users').document(name).get();
                  setState(() {
                    userCredits = userCredits - credit;
                  });
                  if(snapshot.exists){
                    otherCredit = snapshot.data['credits'];
                    print(otherCredit);
                  }
                  otherCredit = otherCredit + credit;
                  firestore.collection('users').document(widget.name).updateData({
                    'credits': userCredits
                  });
                  firestore.collection('users').document(name).updateData({
                    'credits': otherCredit
                  });
                  firestore.collection('transactions').add({
                    'from': widget.name,
                    'to': name,
                    'credits': credit,
                    'timestamp': DateTime.now(),
                  });
                  customDialog(context);
                }
              },
              child: Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  color: Color(0xff1e88e5),
                ),
                child: Center(
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


customDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: Colors.white,
            ),
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width*0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: MediaQuery.of(context).size.width*0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Color(0xff00897b)
                    ),
                    child: Center(
                      child: Text('Send Again', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),)
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                GestureDetector(

                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: MediaQuery.of(context).size.width*0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Color(0xfffb8c00)
                    ),
                    child: Center(
                        child: Text('History', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),)
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
