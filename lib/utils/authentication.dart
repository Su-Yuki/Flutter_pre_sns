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
      print('登録エラーが発生しました');
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
      return true;
    } on FirebaseAuthException catch(e){
      print('signIn error: $e');
      return false;
    }
  }
}