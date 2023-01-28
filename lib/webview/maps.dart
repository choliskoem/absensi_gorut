
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapsPage extends StatefulWidget {
  final String value ;
  MapsPage({Key? key, required this.value,}) : super(key: key);

  @override
  MapsPageState createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: WebView(
        initialUrl: widget.value ,
        javascriptMode: JavascriptMode.unrestricted,

      ),
    );
  }
}



