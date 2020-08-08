import 'dart:io';

import 'package:TheBlueJournal/pages/login/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

void main() {
  // _setTargetPlatformForDesktop();

  runApp(MyApp());
}

void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;

  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }

  Future<void> initData() async {
    // Initialize repository
    await initCoreStore();

    // Initialize parse
    await Parse().initialize(
        "com.thebluejournal", "http://localhost:1337/parse",
        debug: true, coreStore: await CoreStoreSharedPrefsImp.getInstance());

    //parse serve with secure store and desktop support

    //    Parse().initialize(keyParseApplicationId, keyParseServerUrl,
    //        masterKey: keyParseMasterKey,
    //        debug: true,
    //        coreStore: CoreStoreSharedPrefsImp.getInstance());

    // Check server is healthy and live - Debug is on in this instance so check logs for result
    final ParseResponse response = await Parse().healthCheck();

    if (response.success) {
      print("Healthy connection!");
    } else {
      print('Server health check failed');
    }
  }

  Future<void> initInstallation() async {
    final ParseInstallation installation =
        await ParseInstallation.currentInstallation();
    final ParseResponse response = await installation.create();
    print(response);
  }

  // available options:
  /// SharedPreferences - Not secure but will work with older versions of SDK - CoreStoreSharedPrefsImpl
  /// Sembast - NoSQL DB - Has security - CoreStoreSembastImpl
  Future<CoreStore> initCoreStore() async {
    //return CoreStoreSembastImp.getInstance();
    return CoreStoreSharedPrefsImp.getInstance();
  }
}
