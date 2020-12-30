import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

class WebPage extends StatefulWidget {
  String url; String name;
  WebPage(this.url, this.name);
  @override
  _WebPageState createState() => _WebPageState(url, name);
}

class _WebPageState extends State<WebPage> {
  InAppWebViewController webView;
  String url; String name;
  _WebPageState(this.url, this.name);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: Container(
            child: Column(children: <Widget>[
              Expanded(
                  child: InAppWebView(
                  initialUrl: url,
                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      //Enabled cache
                      cacheEnabled: true,
                      debuggingEnabled: true,
                    ),
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onLoadStart: (InAppWebViewController controller,
                      String url) {

                  },
                  onLoadStop: (InAppWebViewController controller,
                      String url) {

                  },
                  onLoadError: (controller, url, code, message) {
                    print(code);
                    print(message);
                  },
                  onLoadHttpError: (controller, url, statusCode,
                      description) {
                    print(statusCode);
                    print(description);
                  },
                ))
            ])),
    );
  }
}


