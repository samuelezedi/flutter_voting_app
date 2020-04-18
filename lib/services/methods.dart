
import 'package:firebase_auth/firebase_auth.dart';

import 'bloc.dart';

class Repo {
  FirebaseMethods m = FirebaseMethods();

  getMyCourseList(user) => m.getMyCourseList(user);

  getCurrentUser() => m.getCurrentUser();

  checkConnection() => m.checkConnection();


  Future signOut () async {
    return m.signOut();
  }

  getUserRole(user) => m.getUserRole(user);

  Future<dynamic> signInWithEmailAndPassword(email, password) => m.signInWithEmailAndPassword(email, password);

  createUserWithEmailAndPassword(String name, String email, String password,context) => m.createUserWithEmailAndPassword(name, email, password,context);

  saveProfilePicture(context, photo,user) {
    return m.saveProfilePicture(context, photo, user);
  }

}