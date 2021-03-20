import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'database/database.dart';
import 'pages/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  PrefService.setDefaultValues({'host': 'student-jwt.herokuapp.com'});
  final DatabaseHelper _dbHelper = DatabaseHelper();
  DatabaseHelper.initDb();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignIn(),
    );
  }
}
