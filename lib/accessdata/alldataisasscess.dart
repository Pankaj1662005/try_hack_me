import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:photo_manager/photo_manager.dart';

class Hackapp extends ChangeNotifier {
  late List<AssetEntity> _galleryImages;
  String deviceName = '';
  String deviceVersion = "";
  String identifier = '';
  List<Contact> contacts = [];
  accessallcontact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(withProperties: true);
    }
  }

  Future<void> loadGalleryImages() async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
    );

    List<AssetEntity> images =
        await albums[0].getAssetListPaged(page: 0, size: albums[0].assetCount);

    _galleryImages = images;
    notifyListeners();
  }

  Future<List<String>> getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
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
}
