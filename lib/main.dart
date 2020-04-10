// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(home: SmartLED()));

class SmartLED extends StatefulWidget {
  @override
  _SmartLEDState createState() => _SmartLEDState();
}

class _SmartLEDState extends State<SmartLED> {
  WebViewController _controller;

  Future<bool> _exitApp() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(),
      child: Scaffold(
        body: WebView(
          initialUrl: 'https://smartled.store/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
        ),
      ),
    );
  }
}
