import 'package:flutter/material.dart';
import 'package:testflutter/src/bloc/auth_bloc.dart';

class MyApp extends InheritedWidget {
  final AuthBloc authBloc;
  final Widget child;
  const MyApp(this.authBloc, this.child, {super.key}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static MyApp? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyApp>();
  }
}
