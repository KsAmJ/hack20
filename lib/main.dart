import 'package:flutter/material.dart';
import 'package:hack20/bloc/general_bloc.dart';
import 'package:hack20/screens/home.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalBloc>(
          create: (_) => GlobalBloc(),
        ),
      ],
      child: MaterialApp(
          title: 'Hack 20',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Poppins',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          //home: HomeScreen(),
          routes: {
            '/': (_) => Home(),
          }),
    );
  }
}
