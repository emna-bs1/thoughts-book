import 'package:flutter/material.dart';

import '../widgets/create_account_form.dart';
import '../widgets/input_decoration.dart';
import '../widgets/login_form.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextController = TextEditingController();

  final TextEditingController _passwordTextController = TextEditingController();

  final GlobalKey<FormState>? _formKey = GlobalKey<FormState>();

  bool isCreatedClicked = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0XFFB9C2D1),
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Sign In',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SizedBox(
                      width: width,
                      height: 400,
                      child: isCreatedClicked
                          ? CreateAccountForm(
                              formKey: _formKey,
                              emailTextController: _emailTextController,
                              passwordTextController: _passwordTextController)
                          : LoginForm(
                              formKey: _formKey,
                              emailTextController: _emailTextController,
                              passwordTextController: _passwordTextController)),
                ),

                /*LoginForm(
                          formKey: _formKey,
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController)),

                )
                       */
                TextButton.icon(
                  icon: const Icon(Icons.portrait_rounded),
                  label: Text(isCreatedClicked
                      ? 'Already have an account'
                      : 'Create account'),
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  )),
                  onPressed: () {
                    setState(() {
                      isCreatedClicked = !isCreatedClicked;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0XFFB9C2D1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
