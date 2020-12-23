import 'package:flutter/material.dart';
import 'main_view.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wikipedia App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Wikipedia App'),
        ),
        body: MainView(),
      )
    );
  }
}