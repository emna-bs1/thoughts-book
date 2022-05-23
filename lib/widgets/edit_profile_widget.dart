import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thoughts/services/service.dart';
import 'package:thoughts/widgets/update_user_profile_dialog.dart';
import '../model/User.dart';
import '../screens/login.dart';

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({
    Key? key,
    required this.current,
  }) : super(key: key);

  final MUser current;

  @override
  Widget build(BuildContext context) {
    final _avatarUrlTextController =
        TextEditingController(text: current.avatarUrl);
    final _displayNameTextController =
        TextEditingController(text: current.displayName);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: 70,
      child: Row(
        children: [
          // add a space
          Column(
            children: [
              Expanded(
                child: InkWell(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(current.avatarUrl!),
                    backgroundColor: Colors.transparent,
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return UpdateUserProfileDialog(
                              width: width,
                              height: height,
                              current: current,
                              avatarUrlTextController: _avatarUrlTextController,
                              displayNameTextController:
                                  _displayNameTextController);
                        });
                  },
                ),
              ),
              Text(
                current.displayName!,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          /*
          Container(
            width: double.infinity,
            child: IconButton(
                icon:
                    const Icon(Icons.logout, size: 90, color: Colors.redAccent),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ));
                  });
                }),
          ), */
        ],
      ),
    );
  }
}
