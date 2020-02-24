

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_app/models/contact.dart';
import 'package:hive_app/screens/contact_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(ContactAdapter());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Contact App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: Hive.openBox('contacts', compactionStrategy: (int total, int deleted){
              return deleted > 40;
            }),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError)
                  return Text(snapshot.error.toString());
                else
                  return ContactPage();
              } else {
                return Scaffold();
              }
            //  return ContactPage();
            }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Hive.box('contacts').compact();
    Hive.box('contacts').close();
    super.dispose();
  }
}




