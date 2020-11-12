import 'package:automatedlinuxterminal/linux_terminal.dart';
import 'package:automatedlinuxterminal/terminal.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
var fireStore = FirebaseFirestore.instance;

//------enumeration---------->

enum FormType { login, register }
//--------------------------->

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<
      FormState>(); //since the parent "form" is responsible for textformfield, we have to define a global varibale.

  String _email;
  String _password;
  String _name;
  bool status;
  var userID;

  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print('Valid');
      return true;
    }
    return false;
  }

//----------------------------------------------
//      Validate, Store, Navigate
//----------------------------------------------
  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          dynamic result = await _auth.signInWithEmailAndPassword(
              email: _email, password: _password);
          User user = result.user;

          print('Signed in: ${user}');
          print('******* USER DETAILS: $user');

          // Query docRef =
          //     fireStore.collection("users").where("email", isEqualTo: _email);

          DocumentReference docRef = fireStore.collection("users").doc();
          DocumentSnapshot docSnap = await docRef.get();
          var doc_id2 = docSnap.reference.documentID;

          print("DOCUMENT REFERENCE: $docRef");
          final uid = user.uid;
          print("ID: $doc_id2");

          if (user != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => MyCLI2(
                          user: user,
                          //clientID: client,
                        )));
          }
        } else {
          dynamic result = await _auth.createUserWithEmailAndPassword(
              email: _email, password: _password);
          User user = result.user;
//----------------------------------------------------------->
//                  Adding collection "users"
//----------------------------------------------------------->
          DocumentReference docRef = fireStore.collection("users").doc();

          var docID = docRef.id;

          docRef.set({
            "name": _name,
            "email": _email,
            "docRefID": docID,
          }).then((value) => null);
          print('document ID: $docID');

//----------------------------------------------------------->
//                  Adding collection "clients"
//----------------------------------------------------------->

          DocumentReference client = fireStore
              .collection("users")
              .doc(docRef.id)
              .collection("clients")
              .doc();
          client.set({
            "IP": "192.168.31.200",
            "deviceName": "Redmi Note 8 pro",
          });

          print('Client ID: ${client.id}');

          print('Registered user: ${user}');
          userID = user.uid;

          if (user != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => MyCLI2(
                          user: user,
                          clientID: client,
                          userDocID: docRef,
                        )));
          }
          return docID;
        }
      } catch (e) {
        print('****Error*****: $e');
      }
    }
  }

//---------------------------------------
//        New User Register
//---------------------------------------

  void moveToRegister() {
    formKey.currentState.reset(); //to clear the previous content of the page
    setState(() {
      //setState() triggers build again, hence creating the page
      _formType = FormType.register;
    });
  }

  //--------------------------------------
  //           Login
  //--------------------------------------

  void moveToLogin() {
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("data"),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: new Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buildInputs() + buildSubmitButtons(),
              ),
            ),
          ),
        ),
      ),
    );
  }

//--------------------------------------------------------------------
//                  Inputs
//--------------------------------------------------------------------
  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: "Email"),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "Password"),
          obscureText: true,
          validator: (value) =>
              value.isEmpty ? 'password can\'t be empty' : null,
          onSaved: (value) => _password = value,
        ),
      ];
    } else {
      return [
        TextFormField(
          decoration: InputDecoration(labelText: "Name"),
          validator: (value) => value.isEmpty ? 'Please enter your name' : null,
          onSaved: (value) => _name = value,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "Email"),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "Password"),
          obscureText: true,
          validator: (value) =>
              value.isEmpty ? 'password can\'t be empty' : null,
          onSaved: (value) => _password = value,
        ),
      ];
    }
  }

  //---------------------------------------------------------------------
  //                    Buttons
  //---------------------------------------------------------------------

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          child: Text("Login"),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          onPressed: moveToRegister,
          child: Text(
            "New User? Sign up",
            style: TextStyle(fontSize: 15.0),
          ),
        ),
      ];
    } else {
      return [
        RaisedButton(
          child: Text("Sign Up"),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          onPressed: moveToLogin,
          child: Text(
            "Already an account? Login",
            style: TextStyle(fontSize: 15.0),
          ),
        ),
      ];
    }
  }
}
