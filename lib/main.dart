import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testflutter/src/bloc/auth_bloc.dart';
import 'package:testflutter/src/resource/login_dart.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyABY6Mi2iDc5LtAfcbkTs6E1cFSyTzkj28",
              appId: "1:837883669749:android:275580ff260e610ffde9bc",
              messagingSenderId: "837883669749",
              projectId: "taxiapp-61193"))
      : await Firebase.initializeApp();
  runApp(MyApp(
      AuthBloc(),
      const MaterialApp(
        home: LoginPage(),
      )));
}
