
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_reach_app/screens/home.dart';

void main(){
  runApp(MeReachApp());
}

class MeReachApp extends StatelessWidget {
  const MeReachApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListaDeServidores(),
    );
  }
}
