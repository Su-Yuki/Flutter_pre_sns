import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sns/View/account/account_settings.dart';
import 'package:flutter_sns/View/account/edit_account_page.dart';
import 'package:flutter_sns/utils/authentication.dart';
import 'package:flutter_sns/utils/firestore/posts.dart';
import 'package:flutter_sns/utils/firestore/users.dart';
import 'package:intl/intl.dart';

import '../../model/account.dart';
import '../../model/post.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Account myAccount = Authentication.myAccount!;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('マイページ', style: TextStyle(color: Colors.black),),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountSetting())
                )
              },
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 15, left: 15, top: 20),
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  foregroundImage: NetworkImage(myAccount.imagePath),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(myAccount.name, style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text('@${myAccount.userId}', style: TextStyle(color: Colors.grey),),
                                  ],
                                )
                              ],
                            ),
                            OutlinedButton(
                                onPressed: () async{
                                  var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditAccountPage()));
                                  if(result == true){
                                    setState(() {
                                      myAccount = Authentication.myAccount!;
                                    });
                                  }
                                },
                                child: Text('編集'),
                            )
                          ],
                        ),
                        SizedBox(height: 18,),
                        Text(myAccount.selfIntroduction),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: const TabBar(
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(text: 'ツイート',),
                        Tab(text: 'いいね',),
                      ],
                    ),
                  ),
                  Expanded(child: StreamBuilder<QuerySnapshot>(
                    stream: UserFirestore
                        .users
                        .doc(myAccount.id)
                        .collection('my_posts')
                        .orderBy('created_time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        List<String> myPostIds = List.generate(snapshot.data!.docs.length, (index) {
                          return snapshot.data!.docs[index].id;
                        });
                        return FutureBuilder<List<Post>?>(
                          future: PostFirestore.getPostsFromIds(myPostIds),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index){
                                    Post post = snapshot.data![index];
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
                                                      Text(DateFormat('y/M/d').format((post.createdTime!.toDate()))),
                                                    ],
                                                  ),
                                                  Text(post.content)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              return Container();
                            }
                          }
                        );
                      } else {
                        return Container();
                      }
                    }
                  ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
