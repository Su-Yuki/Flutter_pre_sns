import 'package:flutter/material.dart';
import 'package:flutter_sns/View/start_up/login_page.dart';
import 'package:flutter_sns/model/account.dart';
import 'package:flutter_sns/utils/authentication.dart';
import 'package:flutter_sns/utils/firestore/users.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({Key? key}) : super(key: key);

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  Account myAccount = Authentication.myAccount!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('アカウント設定', style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 30,),
              ElevatedButton(
                  onPressed: (){
                    Authentication.signOut();
                    while(Navigator.canPop(context)){
                      Navigator.pop(context);
                    }
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => LoginPage()
                    ));
                  },
                  child: Text('ログアウト')
              ),
              SizedBox(height: 50,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: (){
                    UserFirestore.deleteUser(myAccount.id);
                    Authentication.deleteAuth();
                    while(Navigator.canPop(context)){
                      Navigator.pop(context);
                    }
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => LoginPage()
                    ));
                  },
                  child: Text('アカウント削除')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
