import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sns/View/time_line/post_page.dart';
import 'package:flutter_sns/model/account.dart';
import 'package:flutter_sns/model/post.dart';
import 'package:intl/intl.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {

  Account myAccount = Account(
    id:               '1',
    name:             'TestAccount',
    selfIntroduction: 'hello this is test comment',
    userId:           'test_account',
    imagePath:        'https://picsum.photos/200',
    createdTime:      Timestamp.now(),
    updatedTime:      Timestamp.now(),
  );

  List<Post> postList = [
    Post(
      id:            '1',
      content:       'Hello flutter',
      postAccountId: '1',
      createdTime:   DateTime.now(),
    ),
    Post(
      id:            '2',
      content:       'Hi!!! Firebase',
      postAccountId: '2',
      createdTime:   DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('タイムライン', style: TextStyle(color: Colors.black),),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 2,
      ),
      body: ListView.builder(
        itemCount: postList.length,
        itemBuilder: (context, index){
          return Container(
            decoration: BoxDecoration(
              border: index == 0 ? Border(
                top: BorderSide(color: Colors.grey, width: 0),
                bottom: BorderSide(color: Colors.grey, width: 0),
              ) : Border(bottom: BorderSide(color: Colors.grey, width: 0),)
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
             children: [
               CircleAvatar(
                 radius: 20,
                 foregroundImage: NetworkImage(myAccount.imagePath),
               ),
               Expanded(
                 child: Container(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children:[
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             children: [
                               Text(myAccount.name, style: TextStyle(fontWeight: FontWeight.bold),),
                               Text('@${myAccount.userId}', style: TextStyle(color: Colors.grey),),
                             ],
                           ),
                           Text(DateFormat('y/M/d').format((postList[index].createdTime!))),
                         ],
                       ),
                       Text(postList[index].content)
                     ],
                   ),
                 ),
               ),
             ],
            ),
          );
        },
      ),
    );
  }
}
