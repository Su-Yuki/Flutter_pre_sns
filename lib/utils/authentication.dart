import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;

  static Future<dynamic> signUp({required String email, required String pass}) async{
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
      print('登録完了');
      return true;
    } on FirebaseAuthException catch(e){
      return '登録エラーが発生しました';
    }
  }

}