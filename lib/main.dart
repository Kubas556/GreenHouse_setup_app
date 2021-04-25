import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';

void main() {
  
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      visualDensity: VisualDensity.standard
    ),
    home: Home()
  )
  );
}