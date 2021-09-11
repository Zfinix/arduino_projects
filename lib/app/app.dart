// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:arduino_projects/l10n/l10n.dart';
import 'package:arduino_projects/wifi_led/wifi_led_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Socket? sock;
  @override
  void initState() {
    connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: Color(0xFF13B9FF)),
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
       debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales,
      home: sock != null
          ? WifiLEDPage(sock)
          : const Material(
              color: CupertinoColors.systemBackground,
              child: CupertinoActivityIndicator(),
            ),
    );
  }

  void connect() async {
    try {
      // modify with your true address/port
      final _sock = await Socket.connect('192.168.1.105', 80);
      setState(() {
        sock = _sock;
      });
      sock?.listen((e) {
        print('server: ${String.fromCharCodes(e)}');
      }, onError: (_) {
        print('disconnect $_');
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
