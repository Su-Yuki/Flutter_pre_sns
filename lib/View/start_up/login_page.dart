import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sns/View/screen.dart';
import 'package:flutter_sns/View/start_up/create_account_page.dart';
import 'package:flutter_sns/utils/authentication.dart';
import 'package:flutter_sns/utils/firestore/users.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 50,),
              Text('Flutter SNS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: 320,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'メールアドレス'
                    ),
                  ),
                ),
              ),
              Container(
                width: 320,
                child: TextField(
                    controller: passController,
                      decoration: InputDecoration(
                      hintText: 'パスワード'
                  ),
                ),
              ),
              SizedBox(height: 8,),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(text: 'アカウントを作成していない方は'),
                    TextSpan(
                      text: 'こちら',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateAccountPage())
                        );
                      }
                    ),
                  ],
                ),
              ),
              SizedBox(height: 70,),
              ElevatedButton(
                  onPressed: () async{
                    var result = await Authentication.emailSignIn(email: emailController.text, pass: passController.text);
                    if(result is UserCredential){
                      var _result = await UserFirestore.getUser(result.user!.uid);
                      if(_result == true){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Screen())
                        );
                      }
                    }
                  },
                  child: Text('emailでログイン')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
