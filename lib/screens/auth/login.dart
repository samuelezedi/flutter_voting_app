import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voterx/screens/auth/register.dart';
import 'package:voterx/services/methods.dart';
import 'package:voterx/utility/flash.dart';

import '../../main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  BuildContext context;
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool _obscuredText = true;
  Icon _obscuredIcon = Icon(FeatherIcons.eye);
  int _year = new DateTime.now().year;
  bool _isLoading = false;
  bool _emailEnable = true;
  bool _passwordEnable = true;
  bool _emailFocus = false;
  Repo repo = new Repo();


  void _submit() async {
    SharedPreferences local = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
      _emailEnable = false;
      _passwordEnable = false;
    });

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      repo.checkConnection().then((check) {
        if (check) {
          repo
              .signInWithEmailAndPassword(
              _email.toString().trim(), _password.toString().trim())
              .then((user) {


            if (user == null) {
              setState(() {
                _isLoading = false;
                _emailEnable = true;
                _passwordEnable = true;
              });

              Flash().show(context, 2, 'Email or password is incorrect', Colors.black54,
                  15, null, null);
            } else {
              setState(( ) {
                _isLoading = false;
                _emailEnable = true;
                _passwordEnable = true;
              });
            }
          }).catchError((e) {
            Flash()
                .show(context, 2, e.toString(), Colors.black54, 15, null, null);
          });
        } else {
          setState(() {
            _isLoading = false;
            _emailEnable = true;
            _passwordEnable = true;
          });
          Flash().show(context, 2, 'Not Connected to internet', Colors.black54,
              15, null, null);
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
        this.context = context;
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
                          color: Colors.blue),
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
                                _isLoading ? 'Authenticating...' : 'Login',
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
                                  child: Text('Forgot Password?',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15)),
                                  onTap: () {}),
                              InkWell(
                                  child: Text('Register',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15)),
                                  onTap: () {;
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterUser()));

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
                ]),
          ),
        );
      }),
    );
  }
}