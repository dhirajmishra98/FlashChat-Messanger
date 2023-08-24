import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/round_buttons.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _savingSpinner = false;
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;

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
                decoration:
                    kTextButtonDecoration.copyWith(hintText: 'Enter your email'),
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
                decoration: kTextButtonDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundButtons(
                color: Colors.blueAccent,
                text: 'Register',
                onPressed: () async {
                  setState((){
                    _savingSpinner = true;
                  });
                  // try {
                  //   final newUser = await _auth.createUserWithEmailAndPassword(
                  //       email: email, password: password);
                  //   if (newUser != null){
                  //     Navigator.pushNamed(context, ChatScreen.id);
                  //   }
                  //   setState((){
                  //     _savingSpinner = false;
                  //   });
                  // } catch(e){
                  //   setState((){
                  //     _savingSpinner = false;
                  //   });
                  //   print(e);
                  // }
                  try {
                    final newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email!,
                      password: password!,
                    );
                    if (newUser != null){
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState((){
                      _savingSpinner = false;
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    setState((){
                      _savingSpinner = false;
                    });
                    print(e);
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
