import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forward/auth/login.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class Firebase extends Model {
  FirebaseUser _user;
  String _username, _usermail, _userimageurl, _userpassword, _userbio, _useruid;
  bool _userisactive;

  DocumentSnapshot document;

  get username => _username;
  get userimageurl => _userimageurl;
  get usermail => _usermail;
  get userpassword => _userpassword;
  get userbio => _userbio;
  get useruid => _useruid;
  get userisactive => _userisactive;
  get user => _user;

  void setusername(String username) {
    _username = username;
  }

  void setuserimageurl(String userimageurl) {
    _userimageurl = userimageurl;
  }

  void setusermail(String usermail) {
    _usermail = usermail;
  }

  void setuserpassword(String userpassword) {
    _userpassword = userpassword;
  }

  void setuserbio(String userbio) {
    _userbio = userbio;
  }

  void setuseruid(String useruid) {
    _useruid = useruid;
  }

  void setuserisactive(bool userisactive) {
    _userisactive = userisactive;
  }

  void setuser(FirebaseUser user) async {
    _user = user;
    await Firestore.instance.runTransaction((transaction) async {
      document = await transaction
          .get(Firestore.instance.collection('users').document(user.uid));
      _usermail = document.data['usermail'];
      _username = document.data['username'];
      _userisactive = document.data['userisactive'];
      _userimageurl = document.data['userimageurl'];
      _userbio = document.data['userbio'];
    });
  }
}
