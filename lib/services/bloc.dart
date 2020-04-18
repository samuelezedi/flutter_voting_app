import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voterx/utility/flash.dart';


class FirebaseMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore firestore = Firestore.instance;
  SharedPreferences localStorage;

  Future<FirebaseUser> getCurrentUser() async {
    //returns firebase User
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<dynamic> getUserId() async {
    localStorage = await SharedPreferences.getInstance();
    return localStorage.getString('token');
  }

  Future<dynamic> signInWithEmailAndPassword(email, password) async {
    try{
      AuthResult user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return user.user;

    } catch(e){
      print(e.message);
      return null;
    }
  }



  getUserRole(user) async{
    return await firestore.collection('pusers')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();

  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result =  await firestore.collection("pusers")
        .where("email", isEqualTo: user.email)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }


  Future signOut () async {

    localStorage = await SharedPreferences.getInstance();
    var docId = localStorage.getString('userDocId');
    this.getCurrentUser().then((user) async {
      await Firestore.instance.collection('pusers')
          .document(docId).updateData({
        'online':2
      }).then((_) async {
        try{
//      await _googleSignIn.disconnect();
          await localStorage.remove('userData');
          await localStorage.remove('tokenToken');
          await localStorage.remove('chats');
          await localStorage.remove('chatlist');
          await localStorage.remove('semester');
          await localStorage.remove('sem_uid');
          await localStorage.remove('saved');
          await localStorage.remove('date_in_chat');
          await localStorage.clear();
          return await _auth.signOut();
        } catch(e){
          print(e);
        }
      });
    });

  }

  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //connected
        return true;
      }
    } on SocketException catch (_) {
      //not connected
      return false;
    }
  }

  getUserDetail(userid) async {

  }

  Future<bool> storeUserSession(token, body, body2) async {
    localStorage =
    await SharedPreferences.getInstance();
    localStorage.setString('token', body['data']['id']);
    localStorage.setString('user', json.encode(body));
    localStorage.setString(
        'uinfo', json.encode(body2));
    return true;
  }


  getMyCourseList (user) async {
    return firestore.collection('mycourses').where('uid', isEqualTo: user).snapshots();
  }

  createUserWithEmailAndPassword(String name, String email, String password,context) async {
    var currentUser = await _auth.createUserWithEmailAndPassword(
        email: email, password: password
    ).catchError((e){
      Flash().show(context, 2, e.message.toString(), Colors.black54, 15, null,null);
    });
    return currentUser.user;
  }

  saveProfilePicture(context, photo, user) {
    Firestore.instance.collection('pusers')
        .where('uid', isEqualTo: user)
        .getDocuments().then((data){

      Firestore.instance.collection('pusers')
          .document(data.documents[0].documentID)
          .updateData({'photo': photo}).then((_){
        Flash().show(context, 2, 'Updated', Colors.black54, 15, null,null);
      });

    });
    return true;
  }



}