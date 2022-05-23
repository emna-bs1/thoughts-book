import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/User.dart';

class AppService {

  final CollectionReference userCollectionReference = FirebaseFirestore.instance.collection('users');


  Future<void> loginUser(String email, String password) async {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return;
  }

  Future <void> createUser(String displayName, String uid, BuildContext context) async{
    MUser user = MUser(
      avatarUrl: 'https://picsum.photos/200/300',
      displayName: displayName,
      uid: uid);
      userCollectionReference.add(user.toMap());
      return;
  }

  Future<void> update(MUser user, String displayName, String avatarUrl, BuildContext context) async {
    MUser modified = MUser(displayName: displayName, avatarUrl: avatarUrl, uid: user.uid);
    // user.id references the document holding the user
    userCollectionReference.doc(user.id).update(modified.toMap());
    return;
  }
}