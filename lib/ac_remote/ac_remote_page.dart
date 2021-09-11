// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ACRemotePage extends StatefulWidget {
  const ACRemotePage(this.channel, {Key? key}) : super(key: key);

  final Socket? channel;

  @override
  State<ACRemotePage> createState() => _ACRemotePageState();
}

class _ACRemotePageState extends State<ACRemotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoButton(
            color: Colors.red,
            onPressed: _togglePower,
            child: Text('AC On/Off',
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 20.0)),
          ),
          CupertinoButton(
            color: Colors.red,
            onPressed: _fan,
            child: Text('Fan',
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 20.0)),
          ),
          CupertinoButton(
            color: Colors.red,
            onPressed: _mode,
            child: Text('Mode',
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 20.0)),
          ),
          CupertinoButton(
            color: Colors.red,
            onPressed: _tempUp,
            child: Text('Temp Up',
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 20.0)),
          ),
          CupertinoButton(
            color: Colors.red,
            onPressed: _tempDown,
            child: Text('Temp Down',
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 20.0)),
          ),
        ],
      ),
    ));
  }

  void _togglePower() {
    try {
      print(widget.channel?.address);
      print(widget.channel?.port);
      widget.channel!.write('POWER\n');
    } catch (e) {
      print(e.toString());
    }
  }

  void _fan() {
    widget.channel?.write('FAN\n');
  }

  void _mode() {
    widget.channel?.write('MODE\n');
  }

  void _tempUp() {
    widget.channel?.write('TEMPUP\n');
  }

  void _tempDown() {
    widget.channel?.write('TEMPDOWN\n');
  }

  @override
  void dispose() {
    widget.channel?.close();
    super.dispose();
  }
}
