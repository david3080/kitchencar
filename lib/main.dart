import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, //縦固定
  ]);
  runApp(MaterialApp(
    title: 'こここりん',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.lightBlue[100],
      buttonColor: Colors.lightBlue[100],
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.lightBlue[100],
        textTheme: ButtonTextTheme.primary,
      ),
    ),
    home: ProviderScope(
      child: HomePage(),
    ),
  ));
}
