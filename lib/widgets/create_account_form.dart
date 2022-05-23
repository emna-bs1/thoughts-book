import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thoughts/screens/main.dart';
import 'package:thoughts/services/service.dart';
import '../model/User.dart';
import 'input_decoration.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({
    Key? key,
    required TextEditingController emailTextController,
    required TextEditingController passwordTextController,
    GlobalKey<FormState>? formKey,
  })  : _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        _formKey = formKey,
        super(key: key);

  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;
  final GlobalKey<FormState>? _formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text(
                'Please enter a valid email and password that is at least 6 characters'),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? 'Please enter an email' : null;
              },
              controller: _emailTextController,
              decoration: buildInputDecoration('email', 'user@me.com'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? 'Please enter a password' : null;
              },
              controller: _passwordTextController,
              decoration: buildInputDecoration('password', '******'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            style: TextButton.styleFrom(
                primary: Colors.white,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.green,
                textStyle: const TextStyle(
                  fontSize: 15,
                )),
            onPressed: () {
              if (_formKey!.currentState!.validate()) {
                String email = _emailTextController.text;
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: _passwordTextController.text)
                    .then(
                  (value) {
                    if (value.user != null) {
                      String uid = value.user!.uid;
                      AppService()
                          .createUser(email.split('@')[0], uid, context)
                          .then((value){
                            AppService().loginUser(email, _passwordTextController.text)
                            .then((value){
                              return Navigator.push(context, MaterialPageRoute(builder: (context)=> const MainPage()));
                            });
                      });
                    }
                  },
                );
              }
            },
            child: const Text('Create Account'),
          )
        ],
      ),
    );
  }
}
