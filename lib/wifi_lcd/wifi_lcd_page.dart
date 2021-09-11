// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WifiLCDPage extends StatefulWidget {
  const WifiLCDPage(this.channel, {Key? key}) : super(key: key);

  final Socket? channel;

  @override
  State<WifiLCDPage> createState() => _WifiLCDPageState();
}

class _WifiLCDPageState extends State<WifiLCDPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Arduino LCD'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  onSubmitted: sendMessage,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Enter Input',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void sendMessage(String str) {
    try {
      widget.channel
        ?..write('clear')
        ..write(str);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    widget.channel?.close();
    super.dispose();
  }
}
