import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Firestore fireStore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('Transaction History', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),),
              SizedBox(height: MediaQuery.of(context).size.height*0.02,)
            ],
          ),
          backgroundColor: Color(0xff0288d1),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: fireStore.collection('transactions').orderBy('timestamp').snapshots(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              List<Widget> elements = [];
              var users = snapshot.data.documents;
              for(var user in users){
                final int credits = user.data['credits'];
                final String from = user.data['from'];
                final String to = user.data['to'];
                Timestamp time = user.data['timestamp'];
                DateTime timeStamp = DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch*1000);
                DateFormat format = DateFormat.MMMMEEEEd();
                DateFormat format2 = DateFormat.Hm();
                elements.add(Transaction(credit: credits, from: from,to: to,date: format.format(timeStamp),time: format2.format(timeStamp)));
              }
              return ListView(
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

class Transaction extends StatelessWidget {
  Transaction({this.from,this.to,this.credit,this.time,this.date});
  final String from,to, time, date;
  final int credit;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.01),
        color: Color(0xffe3f2fd),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.07, vertical: MediaQuery.of(context).size.height*0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('$from to $to', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Text(credit.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),)
              ],
            ),
            Text('$date $time')
          ],
        ),
      ),
    );
  }
}


