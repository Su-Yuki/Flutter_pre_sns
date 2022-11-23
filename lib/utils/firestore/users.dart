import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sns/model/account.dart';
import 'package:flutter_sns/utils/authentication.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;

  static final CollectionReference users = _firestoreInstance.collection('users');

  static Future<dynamic> setUser(Account newAccount) async{
    try{
      await users.doc(newAccount.id).set({
        'name':              newAccount.name,
        'user_id':           newAccount.userId,
        'self_introduction': newAccount.selfIntroduction,
        'image_path':        newAccount.imagePath,
        'created_time':      Timestamp.now(),
        'updated_time':      Timestamp.now(),
      });
      print('新規ユーザ作成完了');
      return true;
    } on FirebaseException catch(e) {
      print('新規ユーザ作成エラー');
      print(e);
      return false;
    }
  }

  static Future<dynamic> getUser(String uid) async{
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account(
        id: uid,
        name:             data['name'],
        userId:           data['user_id'],
        selfIntroduction: data['self_introduction'],
        imagePath:        data['image_path'],
        createdTime:      data['created_time'],
        updatedTime:      data['updated_time']
      );
      Authentication.myAccount = myAccount;
      print('ユーザ取得完了');
      return true;
    } on FirebaseException catch(e) {
      print('myAccount Error');
      print(e);
    }
  }

  static Future<dynamic> updateUser(Account updateAccount) async{
    try{
      users.doc(updateAccount.id).update({
        'name':              updateAccount.name,
        'user_id':           updateAccount.userId,
        'self_introduction': updateAccount.selfIntroduction,
        'image_path':        updateAccount.imagePath,
        'updated_time':      Timestamp.now(),
      });
      print('更新成功');
      return true;
    } on FirebaseException catch(e) {
      print('更新失敗');
      return false;
    }
  }
}