import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class WebPage extends StatefulWidget {
  String url; String name;
  WebPage(this.url, this.name);
  @override
  _WebPageState createState() => _WebPageState(url, name);
}

class _WebPageState extends State<WebPage> {
  bool isLoading=true;

  final Completer<WebViewController> _controller = Completer<WebViewController>();
  String url; String name;
  _WebPageState(this.url, this.name);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl : url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? Center( child: CircularProgressIndicator())
              : Stack(),
        ],
      )
    );
  }
}
