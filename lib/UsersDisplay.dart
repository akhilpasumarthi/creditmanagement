import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creditmanagement/UserPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<String> people = [];

class UsersDisplay extends StatefulWidget {
  @override
  _UsersDisplayState createState() => _UsersDisplayState();
}

class _UsersDisplayState extends State<UsersDisplay> {
  Firestore fireStore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('Users', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),),
            SizedBox(height: MediaQuery.of(context).size.height*0.02,)
          ],
        ),
        backgroundColor: Color(0xff0288d1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection('users').snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            List<Widget> elements = [];
            var users = snapshot.data.documents;
            for(var user in users){
              final int credits = user.data['credits'];
              final String email = user.data['email'];
              final String name = user.data['name'];
              people.add(name);
              elements.add(ScoreCard(name: name,email: email,credits: credits,));
            }
            return GridView.count(
              padding: EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 7,
              crossAxisCount: 2,
              children: elements,
            );
          }
          return Center(
            child: Text('No Records Found', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
          );
        },
      )
    );
  }
}


class ScoreCard extends StatelessWidget {
  ScoreCard({this.name,this.email,this.credits});
  final int credits;
  final String name,email;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print(people);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserPage(people: people, credit: credits,name: name,email: email,)));
      },
      child: Card(
        color: Color(0xffbbdefb),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: Color(0xff283593)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(credits.toString(), style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Color(0xff1976d2))),
              SizedBox(
                height: 3,
              ),
              Text(email, style: TextStyle(fontSize: 13, color: Color(0xff1976d2)), textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }
}

