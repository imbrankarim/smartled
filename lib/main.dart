// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:minimize_app/minimize_app.dart';

void main() => runApp(MaterialApp(home: SmartLED()));

class SmartLED extends StatefulWidget {
  @override
  _SmartLEDState createState() => _SmartLEDState();
}

WebViewController controllerGlobal;

Future<bool> _exitApp(BuildContext context) async {
  if (await controllerGlobal.canGoBack()) {
    print("onwill goback");
    controllerGlobal.goBack();
  } else {
    MinimizeApp.minimizeApp();
    return Future.value(false);
  }
}

class _SmartLEDState extends State<SmartLED> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SMARTLED'),
          // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
          actions: <Widget>[
            NavigationControls(_controller.future),
          ],
        ),
        // We're using a Builder here so we have a context that is below the Scaffold
        // to allow calling Scaffold.of(context) so we can show a snackbar.
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: 'https://smartled.store/',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            // TODO(iskakaushik): Remove this when collection literals makes it to stable.
            // ignore: prefer_collection_literals
            navigationDelegate: (NavigationRequest request) {
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
          );
        }),
      ),
    );
  }  
}



class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        controllerGlobal = controller;

        return Row(
          children: <Widget>[
            // IconButton(
            //   icon: const Icon(Icons.arrow_back_ios),
            //   onPressed: !webViewReady
            //       ? null
            //       : () async {
            //     if (await controller.canGoBack()) {
            //       controller.goBack();
            //     } else {
            //       MinimizeApp.minimizeApp();
            //       return;
            //     }
            //   },
            // ),
            // IconButton(
            //   icon: const Icon(Icons.arrow_forward_ios),
            //   onPressed: !webViewReady
            //       ? null
            //       : () async {
            //     if (await controller.canGoForward()) {
            //       controller.goForward();
            //     } else {
            //       Scaffold.of(context).showSnackBar(
            //         const SnackBar(
            //             content: Text("No forward history item")),
            //       );
            //       return;
            //     }
            //   },
            // ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                controller.reload();
              },
            ),
          ],
        );
      },
    );
  }
}