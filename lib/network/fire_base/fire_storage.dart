import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  final fireStorage = FirebaseStorage.instance;

  Future<void> uploadImage(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);
    try {
      await fireStorage.ref(fileName).putFile(file);
    } on FirebaseException catch (e) {
      print('Error in uploadFile: $e');
    }
  }

  Future<void> uploadUserAvatar({
    required String filePath,
    required String fileName,
  }) async {
    File file = File(filePath);
    try {
      await fireStorage.ref().child('/user/avatar/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      print('Error in uploadFile: $e');
    }
  }

  Future<ListResult> listFiles() async {
    ListResult listResult = await fireStorage.ref('products/images').listAll();
    return listResult;
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL =
        await fireStorage.ref().child(imageName).getDownloadURL();
    return downloadURL;
  }
}
