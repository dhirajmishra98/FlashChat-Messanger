
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/round_buttons.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _savingSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _savingSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 100.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextButtonDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextButtonDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundButtons(
                color: Colors.lightBlueAccent,
                text: 'Log In',
                onPressed: () async{
                  setState((){
                    _savingSpinner = true;
                  });
                  // try {
                  //   final user = await _auth.signInWithEmailAndPassword(
                  //       email: email, password: password);
                  //   if (user != null){
                  //     Navigator.pushNamed(context, ChatScreen.id);
                  //   }
                  //   setState((){
                  //     _savingSpinner = false;
                  //   });
                  // } catch (e){
                  //   setState((){
                  //     _savingSpinner = false;
                  //   });
                  //   print(e);
                  // }
                  try {
                    final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email,
                        password: password
                    );
                    if (user != null){
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState((){
                      _savingSpinner = false;
                    });
                  } on FirebaseAuthException catch (e) {
                    setState((){
                      _savingSpinner = false;
                    });
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
