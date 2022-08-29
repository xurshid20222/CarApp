

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RemoteService{

  static final remoteConfig = FirebaseRemoteConfig.instance;

  static final Map<String, dynamic> themeBackgroundColors = {
    'black' : Colors.black,
    'white' : Colors.white,
    'grey' : Colors.blueGrey.shade700,
  };

  static final Map<String, dynamic> themeTextColors = {
    'black' : Colors.black,
    'white' : Colors.white,
    'green' : Colors.green,
  };

  static final Map<String, dynamic> changesIcons = {
    'white' : const Icon(Icons.more_horiz, color: Colors.white,),
    'black' : const Icon(Icons.more_horiz, color: Colors.black,),
    'white_w' : const Icon(CupertinoIcons.car_detailed, color: Colors.white,),
  };

  static String defaultIconColor = 'white';
  static String defaultTextColor = 'black';
  static String defaultBKColor = 'white';


  static Future<void> initConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 10)));


    await remoteConfig.setDefaults(const {
      'background_color' : 'white',
      'text_color' : 'black',
      'realty_icon' : 'more_b'
    });

    await fetchConfig();
  }

  static Future<void> fetchConfig() async {
    await remoteConfig.fetchAndActivate().then((value) => {
      defaultIconColor = remoteConfig.getString('realty_icon').isNotEmpty ?
          remoteConfig.getString('realty_icon') :
          'more_w',
      defaultBKColor = remoteConfig.getString('background_color').isNotEmpty ?
          remoteConfig.getString('background_color') :
          'white',
      defaultTextColor = remoteConfig.getString('text_color').isNotEmpty ?
          remoteConfig.getString('text_color') :
          'black'
    });
  }

}