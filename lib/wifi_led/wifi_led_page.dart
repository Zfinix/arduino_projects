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

class WifiLEDPage extends StatefulWidget {
  const WifiLEDPage(this.channel, {Key? key}) : super(key: key);

  final Socket? channel;

  @override
  State<WifiLEDPage> createState() => _WifiLEDPageState();
}

class _WifiLEDPageState extends State<WifiLEDPage> {
  var val = -255.0;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Arduino LED'),
        ),
        child: Material(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*  TextField(
                        onSubmitted: sendMessage,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Enter Input',
                          border: OutlineInputBorder(),
                        ),
                      ), */

                      Text(
                        'Brightness: '
                        '${((255 - val.toInt().abs()) / 255 * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(20),
                      RotatedBox(
                        quarterTurns: 3,
                        child: SizedBox(
                          width: 200,
                          child: Slider.adaptive(
                            value: val,
                            min: -255,
                            max: 0,
                            onChanged: sendMessage,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void sendMessage(double v) {
    try {
      setState(() {
        val = v.roundToDouble();
      });
      widget.channel?..write('clear\n')..write('${val.toInt().abs()}\n');
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
