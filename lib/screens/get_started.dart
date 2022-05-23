import 'package:flutter/material.dart';
import 'login.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CircleAvatar(
      backgroundColor: const Color(0XFFF5F6F8),
      child: Column(
        children: [
          const Spacer(),
          Text(
            'ThoughtsBook',
            // get the text theme that we set initially for the app
            style: Theme.of(context).textTheme.headline3,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            '"Document Your Life"',
            style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black26),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold)),
              icon: const Icon(Icons.login_rounded),
              label: const Text('Sign In to Get Started'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login()));
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    ));
  }
}
