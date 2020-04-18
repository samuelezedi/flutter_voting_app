
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voterx/screens/index.dart';

bool isLoggedIn = false;
var deviceId;
var deviceName;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voting App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


    //save if user is loggedIn
    checkUser() async {
      SharedPreferences local = await SharedPreferences.getInstance();
      var chkk = local.getInt('loggedIn');
      if(chkk != null){
        isLoggedIn = true;
      }
      setState(() {
        moveOn = true;
      });
    }

    bool moveOn = false;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: moveOn ? Index() : Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
