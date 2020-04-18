import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
              setState(() {
                _isLoading = false;
                _emailEnable = true;
                _passwordEnable = true;
              });

              Firestore.instance
                  .collection('pusers')
                  .where('uid', isEqualTo: user.uid)
                  .where('puid', isEqualTo: deviceId)
                  .getDocuments()
                  .then((u) {

                if (u.documents.length > 0) {

                  Firestore.instance
                      .collection('pusers')
                      .document(u.documents[0].documentID)
                      .updateData({'online': 1}).then((_) {
                    local.setString('userDocId', u.documents[0].documentID);
                    isLoggedInNow = true;

                    local.setInt('saved', 1);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ReleaseList()));

                  }).catchError((e) {});
                } else {

                  // we do critical investigations
                  Firestore.instance.collection('pusers')
                      .where('uid', isEqualTo: user.uid)
                      .getDocuments().then((u){

                    if(u.documents[0]['pname'] == deviceName && u.documents[0]['pboard'] == deviceBoard && u.documents[0]['pmodel'] == deviceModelId){
                      //mean this user owns this account but probably updated or deleted the app, so we'll grant access
                      //so we'll update his puid, and delete this new entry
                      var docIdofNew;
                      Firestore.instance.collection('pusers')
                          .where('puid', isEqualTo: deviceId)
                          .getDocuments().then((_){
                        docIdofNew = _.documents[0].documentID;

                        //update
                        Firestore.instance.collection('pusers')
                            .document(u.documents[0].documentID)
                            .updateData({'puid' : deviceId}).then((v){

                          //delete new entry
                          Firestore.instance.collection('pusers')
                              .document(docIdofNew)
                              .delete().then((_){
                            Firestore.instance
                                .collection('pusers')
                                .document(u.documents[0].documentID)
                                .updateData({'online': 1}).then((_) {
                              local.setString('userDocId', u.documents[0].documentID);
                              isLoggedIn = true;

                              local.setInt('saved', 1);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => ReleaseList()));

                            }).catchError((e) {});
                          });
                        });
                      });

                    } else {

                      //                  Flash().show(
//                      context,
//                      2,
//                      'This device is registered to an account already',
//                      Colors.black54,
//                      15,
//                      null,
//                      null);

                      FirebaseAuth.instance.signOut();

                    }
                  });

                }

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(LineIcons.arrow_left,color: Colors.black,),
        ),
      ),
        body: Builder(
          builder: (context) {
            this.context = context;
            return Container(
              child: Column(
                children: <Widget>[

                ],
              ),
            );
          }
        )
    );
  }
}
