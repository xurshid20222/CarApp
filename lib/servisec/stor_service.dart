import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class StorageService {
  static final _storage = FirebaseStorage.instance.ref();
  static const folder = "car_images";
  static const listFolder = "car_images_list";

  static Future<String> uploadImage(File image) async {
    String imageName = "image_${DateTime.now()}";
    Reference reference = _storage.child(folder).child(imageName);

    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<List<String>> uploadImages(List<File> files) async {
    List<String> paths = [];
    for (var i in files) {
      paths.add(await uploadImage(i));
    }
    return paths;
  }
}