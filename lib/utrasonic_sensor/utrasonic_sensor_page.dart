// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class UtrasonicSensorPage extends StatefulWidget {
  const UtrasonicSensorPage(this.channel, {Key? key}) : super(key: key);

  final Socket? channel;
 
  @override
  State<UtrasonicSensorPage> createState() => _UtrasonicSensorPageState();
}

class _UtrasonicSensorPageState extends State<UtrasonicSensorPage> {
  String mode = 'cm';
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Arduino LED'),
        ),
        child: Material(
          child: Center(
            child: StreamBuilder<String>(
                stream: widget.channel!
                    .asBroadcastStream()
                    .map((e) => String.fromCharCodes(e)),
                builder: (context, data) {
                  if (data.hasData == false) {
                    return Container();
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Distance: '
                                '${data.data}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ),
        ));
  }

  void switchMode(String _) {
    try {
      setState(() {
        mode = _;
      });
      widget.channel?.write(mode);
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
