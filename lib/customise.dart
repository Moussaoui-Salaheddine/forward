import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';
import 'package:forward/widgets/gradientraisedbutton.dart';
import 'package:image_picker/image_picker.dart';

class Customise extends StatefulWidget {
  @override
  _CustomiseState createState() => _CustomiseState();
}

class _CustomiseState extends State<Customise> {
  String _newbio, _newpassword, _newusername;
  final GlobalKey<FormState> _newusernamekey = GlobalKey<FormState>();
  final GlobalKey<FormState> _newbiokey = GlobalKey<FormState>();
  final GlobalKey<FormState> _newpasswordkey = GlobalKey<FormState>();
  Widget _buildCustomise(BuildContext context, DocumentSnapshot document) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.width / 3,
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: InkWell(
                  onTap: () {
                    _takePicture(ImageSource.gallery);
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            document['userimageurl'].toString()),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.black54,
                      ),
                      Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 30),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 20,
                  left: 20,
                  right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Form(
                      key: _newusernamekey,
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: document['username'].toString()),
                        validator: (input) {
                          if (input.length == 0) {
                            return 'username is empty';
                          }
                        },
                        onSaved: (input) {
                          _newusername = input;
                        },
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 20),
                      child: Form(
                        key: _newbiokey,
                        child: TextFormField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              hintText: document['userbio'].toString()),
                          validator: (input) {
                            if (input.length == 0) {
                              return 'bio is empty';
                            }
                          },
                          onSaved: (input) {
                            _newbio = input;
                          },
                        ),
                      )),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 20,
                    left: 20,
                    right: 20),
                child: Form(
                  key: _newpasswordkey,
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: document['userpassword'].toString()),
                    validator: (input) {
                      if (input.length < 6) {
                        return 'new password is less than 6 characters';
                      }
                    },
                    onSaved: (input) {
                      _newpassword = input;
                    },
                  ),
                )),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
              child: RaisedGradientButton(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  'update',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat Medium'),
                ),
                gradient: LinearGradient(
                  colors: <Color>[
                    Color.fromRGBO(102, 140, 255, 1.0),
                    Color.fromRGBO(110, 62, 220, 1.0)
                  ],
                ),
                onPressed: update,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: DynamicTheme.darkthemeEnabled
            ? DynamicTheme.darktheme
            : DynamicTheme.lightheme,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Customise profile'),
            centerTitle: true,
          ),
          body: Container(
            child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(Firebase.getUser().uid.toString())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: Text('Loading...'));
                else {
                  Firebase.setUsername(snapshot.data['username'].toString());
                  Firebase.setUserimageurl(
                      snapshot.data['userimageurl'].toString());
                  return _buildCustomise(context, snapshot.data);
                }
              },
            ),
          ),
        ));
  }

  Future<void> update() async {
    _newusernamekey.currentState.save();
    _newbiokey.currentState.save();
    _newpasswordkey.currentState.save();
    if (_newusername != null && _newusername != "") {
      if (_newusernamekey.currentState.validate()) {
        await Firestore.instance.runTransaction((transaction) async {
          await transaction.update(
              Firestore.instance
                  .collection("users")
                  .document(Firebase.getUser().uid),
              {"username": _newusername});
        });
      }
    }
    if (_newbio != null && _newbio != "") {
      if (_newbiokey.currentState.validate()) {
        await Firestore.instance.runTransaction((transaction) async {
          await transaction.update(
              Firestore.instance
                  .collection("users")
                  .document(Firebase.getUser().uid),
              {"userbio": _newbio});
        });
      }
    }
    if (_newpassword != null && _newpassword != "" && _newpassword.length > 6) {
      if (_newpasswordkey.currentState.validate()) {
        await Firestore.instance.runTransaction((transaction) async {
          await transaction.update(
              Firestore.instance
                  .collection("users")
                  .document(Firebase.getUser().uid),
              {"userpassword": _newpassword});
        });
        await Firebase.getUser().updatePassword(_newpassword);
      }
    }
    Navigator.pop(context);
  }

  static final basestorage = FirebaseStorage.instance.ref();
  final StorageReference storageusers =
      basestorage.child("image" + Firebase.getUsername().toString());
  final StorageReference storagemessages = basestorage.child("messages");

  Future<String> savePicture(File file) async {
    StorageUploadTask storageUploadTask = storageusers.putFile(file);
    StorageTaskSnapshot snapshot = await storageUploadTask.onComplete;
    print(snapshot.ref.getDownloadURL());
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<void> _takePicture(ImageSource source) async {
    File image;
    image = await ImagePicker.pickImage(
        source: source, maxWidth: 500.0, maxHeight: 500.0);
    savePicture(image).then((string) async {
      await Firestore.instance.runTransaction((transaction) async {
        await transaction.update(
            Firestore.instance
                .collection("users")
                .document(Firebase.getUser().uid),
            {"userimageurl": string});
      });
    });
  }
}
