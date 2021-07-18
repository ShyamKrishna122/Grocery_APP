import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../screens/main_screen.dart';
import '../models/userModel.dart';

class AuthProvider {
  Future<bool> loginWithPhone(String phone, BuildContext context) async {
    final _codeController = TextEditingController();
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          UserCredential result = await _auth.signInWithCredential(credential);

          User user = result.user;

          if (user != null) {
            AppUser.set(phone);
            Navigator.pushReplacementNamed(context, MainScreen.routeName);
          } else {
            Fluttertoast.showToast(msg: "Error");
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          Fluttertoast.showToast(msg: exception.toString());
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Enter OTP"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId, smsCode: code);

                        UserCredential result =
                            await _auth.signInWithCredential(credential);

                        User user = result.user;

                        if (user != null) {
                          AppUser.set(phone);
                          Navigator.pushReplacementNamed(
                              context, MainScreen.routeName);
                        } else {
                          Fluttertoast.showToast(msg: "Error");
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (id) => {});
  }
}
