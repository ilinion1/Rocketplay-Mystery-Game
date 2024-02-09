import 'dart:developer';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mystery/source/features/app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  var status = await AppTrackingTransparency.requestTrackingAuthorization();
  if (status == TrackingStatus.notDetermined) {
    status = await AppTrackingTransparency.requestTrackingAuthorization();
  }
  if (status == TrackingStatus.authorized) {
    log('Permission granted');
  } else {
    log('Permission denied');
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(App(pref: pref)),
  );
}
