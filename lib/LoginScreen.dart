import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'BodyProgress.dart';
import 'SpellHelperHome.dart';
import 'ResetPasswordPage.dart';
import 'SignupPage.dart';
import 'LoginPage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LoginScreen3 extends StatefulWidget {
  @override
  _LoginScreen3State createState() => new _LoginScreen3State();
}

class _LoginScreen3State extends State<LoginScreen3>
    with TickerProviderStateMixin {

  PageController _controller = new PageController(initialPage: 1, viewportFraction: 1.0);

  String email;
  String password;
  String confirmPassword;
  String formError;
  String resetPasswordEmail;
  String loginEmail;
  String loginPassword;
  bool isLoading = false;


  @override
  initState() {
    super.initState();
    setState(() {
      isLoading = false;
      formError = '';
    });
  }

  
  updateField(String fieldId, String value) {
    switch (fieldId) {
          case "email":
            email = value;
            break;
          case "password":
            password = value;
            break;
          case "confirmPassword":
            confirmPassword = value;
            break;
          case "resetPasswordEmail":
            resetPasswordEmail = value;
            break;
          case "loginEmail":
            loginEmail = value;
            break;
          case "loginPassword":
            loginPassword = value;
            break;
          default:
    }

  }

  resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: resetPasswordEmail);
    } catch(e) {
      setState(() {
            formError = '!!! Unable to send email. Please try again';
         });
      return;
    }
    setState(() {
      formError = 'Email sent. Please reset password';
    });
  }

  login() async {
    if (loginEmail == '' || loginPassword == '' || loginEmail == null || loginPassword == null) {
         setState(() {
            formError = 'All the below fields should be completed';
         });
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      FirebaseUser currentUser = await _auth.signInWithEmailAndPassword(email: loginEmail, password: loginPassword);
      getUserList(currentUser.uid);
    } catch(e) {
      setState(() {
        isLoading = false;
            formError = 'Error while logging in. Please try again';
         });
    }
  }

  registerNewUser() async {
    if (password == '' || confirmPassword == '' || email == '' ||
       email == null || confirmPassword == null || password == null) {
         setState(() {
            formError = 'All the below fields should be completed';
         });
      return;
    }
    if (password != confirmPassword) {
      setState(() {
        formError = 'PASSWORD and CONFIRM PASSWORD values should match';
      });
      return;
    }
    setState(() {
        isLoading = true;
        formError = '';
      });
    try {
      FirebaseUser newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      getUserList(newUser.uid);
    } catch(e) {
      setState(() {
        isLoading = false;
            formError = '!!!  Error while creating user. Please try again';
         });
    }
  }

  getUserList(uid) async {
    List userLists;
    QuerySnapshot documents = await Firestore.instance.collection('Lists').getDocuments();
    DocumentReference userQuery = Firestore.instance.collection('UserList')
        .document(uid);
      userQuery.get().then((data) async { 
          if (!data.exists) {
            List lists = documents.documents.map((DocumentSnapshot document) {
                  return {
                    'name': document['name'],
                    'level': document['level'],
                    'order': document['order'],
                    'values': document['values'],
                  };
                }).toList();
            Map<String, Object> userData = {
                'userId': uid,
                'lists': lists
              };
            await userQuery
              .setData(userData);
            userLists = lists;
            
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SpellHelperHome(lists: userLists, userId: uid,)),
            );
          } else {
            userLists = data['lists'];
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SpellHelperHome(lists: userLists, userId: uid,)),
            );
          }
          setState(() {
              isLoading = false;
            });
      });
  }

  gotoLogin() {
    setState(() {
            formError = '';
         });
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      1,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoResetPassword() {
    setState(() {
            formError = '';
         });
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignup() {
    setState(() {
            formError = '';
         });
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

   void signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    FirebaseUser currentUser = await _auth.currentUser();
    print(currentUser);
    if (currentUser == null) {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
       print(googleAuth);
          currentUser = await _auth.signInWithGoogle(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
      
    } 
    getUserList(currentUser.uid);
  }

  loginView() {
    return SingleChildScrollView(
      child: Container(
            height: MediaQuery.of(context).size.height + 200.0,
             child: PageView(
              controller: _controller,
              physics: new AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                SignupPage(
                  formError: this.formError,
                  gotoLogin: this.gotoLogin,
                  registerNewUser: this.registerNewUser,
                  updateField: this.updateField,
                ), 
                LoginPage(
                  formError: this.formError,
                  updateField: this.updateField,
                  gotoResetPassword: this.gotoResetPassword,
                  gotoSignup: this.gotoSignup,
                  login: this.login,
                  signInWithGoogle: this.signInWithGoogle,
                ), 
                ResetPasswordPage(
                  formError: this.formError,
                  gotoLogin: this.gotoLogin,
                  updateField: this.updateField,
                  resetPassword: this.resetPassword,
                )
                ],
              scrollDirection: Axis.horizontal,
            )
          )
    );
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? BodyProgress() : loginView();
  }
}