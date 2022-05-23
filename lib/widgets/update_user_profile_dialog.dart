import 'package:flutter/material.dart';

import '../model/User.dart';
import '../services/service.dart';

class UpdateUserProfileDialog extends StatelessWidget {
  const UpdateUserProfileDialog({
    Key? key,
    required this.width,
    required this.height,
    required this.current,
    required TextEditingController avatarUrlTextController,
    required TextEditingController displayNameTextController,
  })
      : _avatarUrlTextController = avatarUrlTextController,
        _displayNameTextController = displayNameTextController,
        super(key: key);

  final double width;
  final double height;
  final MUser current;
  final TextEditingController _avatarUrlTextController;
  final TextEditingController _displayNameTextController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: width,
        height: height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            Text('Welcome ${current.displayName}',
                style: Theme
                    .of(context)
                    .textTheme
                    .headline5),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: width * 0.8,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {},
                    controller: _avatarUrlTextController,
                  ),
                  TextFormField(
                    validator: (value) {},
                    controller:
                    _displayNameTextController,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.green,
                        elevation: 4,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(15)),
                            side: BorderSide(
                                color: Colors.green,
                                width: 1))),
                    onPressed: () {
                      AppService()
                          .update(current,
                          _displayNameTextController.text,
                          _avatarUrlTextController.text,
                          context
                      );
                      // delay before getting out
                      Future.delayed(const Duration(
                          milliseconds: 200
                      )).then((value) {
                        return Navigator.of(context).pop();
                      });
                    },
                    child:
                    const Text('Update Profile Info'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}