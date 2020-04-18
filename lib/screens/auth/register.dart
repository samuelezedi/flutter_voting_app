import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voterx/services/methods.dart';
import 'package:voterx/utility/flash.dart';
import 'package:voterx/utility/utils.dart';

import '../../main.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  BuildContext maincontext;
  final _formKey = GlobalKey<FormState>();
  String _email, _password,_name;
  bool _obscuredText = true;
  Icon _obscuredIcon = Icon(FeatherIcons.eye);
  int _year = new DateTime.now().year;
  bool _isLoading = false;
  bool _emailEnable = true;
  bool _passwordEnable = true;
  Repo repo = Repo();


  keep(user, value, username) async {
    SharedPreferences local = await SharedPreferences.getInstance();
    var uid = local.getString('userData');
    var token = local.getString('userToken');

    await Firestore.instance
        .collection('/pusers')
        .where('puid', isEqualTo: uid)
        .getDocuments()
        .then(( chk ) async {
      if (chk.documents.isEmpty) {
        Firestore.instance.collection('pusers').add({
          'puid': uid,
          'ptoken': token,
          'substatus': 2,
          'time_joined': Timestamp.now(),
          'name': username,
          'email': user.email,
          'online': "1",
          'role': "3",
          'uid': user.uid,
          'coins': 0,
          'wcoins' : 0
        });
      } else {
        //mean existed before
        Firestore.instance.collection('pusers')
            .document(chk.documents[0].documentID)
            .setData({
          'name': username,
          'email': user.email,
          'online': "1",
          'role': "3",
          'uid': user.uid,
          'coins': 0,
          'wcoins' : 0
        }, merge: true);
      }

      local.setString('userDocId', chk.documents[0].documentID);
      isLoggedIn = true;


      local.setInt('saved', 1);

    });

  }

  generateUsername() {
    Random random = new Random();
    return random.nextInt(99999) + 10000;
  }

  Future<bool> authenticateUser(FirebaseUser user) async
  {
    QuerySnapshot result =  await Firestore.instance.collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }

  _submit() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
      _emailEnable = false;
      _passwordEnable = false;
    });

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      repo.checkConnection().then((check){
        if(check){
          repo.createUserWithEmailAndPassword(_name, _email, _password, context).then((user) async{

            local = await SharedPreferences.getInstance();

            authenticateUser(user).then(( value ) async {

              if (value) {
                //signUser up


                    Firestore.instance.collection('users')
                        .add({
                      'name': _name,
                      'email': user.email,
                      'online': "1",
                      'role': "3",
                      'uid': user.uid,
                      'username' : Utils().generateUsername(user.email).toString() + 'u',
                      'phone' : '',
                      'blocked': false,
                    } );

                    isLoggedIn = true;
                    local.setInt('loggedIn', 1);
//                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyPolls()));




              } else {

                //user already exists
                // Navigate to next screen
                isLoggedIn = true;
                local.setInt('saved', 1);

              }
            });

          });

        }
        else {
          setState(() {
            _isLoading = false;
            _emailEnable = true;
            _passwordEnable = true;
          });
          Flash().show(context, 2, 'Not Connected to internet', Colors.black54, 15, null, null);
        }
      });


    } else {
      setState(() {
        _isLoading = false;
        _emailEnable = true;
        _passwordEnable = true;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;

    return Scaffold(
      body: Builder(builder: (context) {
        this.maincontext = context;
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),

                  Flexible(
                    child: Text(
                      'VoterX.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40.0,
                          color: Colors.blue
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            child: TextFormField(
                              style: TextStyle(
                                color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              enabled: _emailEnable,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              validator: (input) => !input.trim().isNotEmpty
                                  ? 'Please Enter your name'
                                  : null,
                              onSaved: (input) => _name = input,
                            )),


                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            child: TextFormField(
                              style: TextStyle(
                                color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              enabled: _emailEnable,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              validator: (input) => !input.contains('@')
                                  ? 'Please Enter a Valid Email'
                                  : null,
                              onSaved: (input) => _email = input,
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            child: TextFormField(
                              enabled: _passwordEnable,
                              style: TextStyle(
                                color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: _obscuredIcon,
                                    color: brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    iconSize: 15,
                                    onPressed: () {
                                      setState(() {
                                        _obscuredIcon = _obscuredText
                                            ? Icon(FeatherIcons.eyeOff)
                                            : Icon(FeatherIcons.eye);
                                        _obscuredText =
                                        _obscuredText ? false : true;
                                      });
                                    },
                                  ),
                                  labelText: 'Password'),
                              validator: (input) => input.length < 6
                                  ? 'Please Enter your Password'
                                  : input == null
                                  ? 'Please enter a valid password'
                                  : null,
                              onSaved: (input) => _password = input,
                              obscureText: _obscuredText,
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 20.0),
                          child: MaterialButton(
                            onPressed: _isLoading ? null : _submit,
                            disabledColor: Colors.grey,
                            color: Colors.blue,
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                                _isLoading ? 'Registering...' : 'Register',
                                style: TextStyle(
                                    color: brightness == Brightness.dark
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 18.0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
//                              side: BorderSide(color: Colors.red)
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[


                              InkWell(
                                  child: Text('Already have an account? Sign In',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15)),
                                  onTap: ()  {
                                    Navigator.pop(context);
                                  }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),

                      ],
                    ),
                  )
                ]
            ),
          ),
        );
      }),
    );
  }
}
