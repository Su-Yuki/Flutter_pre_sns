import 'package:firebase_auth/firebase_auth.dart';

import '../model/account.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User?    currentFirebaseUser;
  static Account? myAccount;


  static Future<dynamic> signUp({required String email, required String pass}) async{
    try{
      UserCredential newAccount = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
      print('登録完了');
      return newAccount;
    } on FirebaseAuthException catch(e){
      print('登録エラーが発生しました');
      print(e);
      return false;
    }
  }

  static Future<dynamic> emailSignIn({required String email, required String pass}) async {
    try {
      final UserCredential _result = await _firebaseAuth.signInWithEmailAndPassword(
          email:    email,
          password: pass
      );
      currentFirebaseUser = _result.user;
      print('signIn sucsess');
      return _result;
    } on FirebaseAuthException catch(e){
      print('signIn error: $e');
      return false;
    }
  }

  static Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  static Future<void> deleteAuth() async{
    await currentFirebaseUser!.delete();
  }
}