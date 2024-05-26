import 'package:faturami_tara/islemler.dart';
import 'package:flutter/material.dart';
//import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _selectedIndex =0;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: Center(child: FotoSecCek()),
    floatingActionButton: FloatingActionButton(onPressed: () {
      
    },
    child: const Icon(Icons.abc),),
    );
  }
}