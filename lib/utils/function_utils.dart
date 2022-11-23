import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FunctionUtils {
  static Future<dynamic> getImageFromGallery() async{
    ImagePicker picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  static Future<String> uploadImage(String uid, File image) async{
    final FirebaseStorage storageInstanse = FirebaseStorage.instance;
    final Reference ref                   = storageInstanse.ref();
    await ref.child(uid).putFile(image);

    String downloadUrl = await storageInstanse.ref(uid).getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }
}