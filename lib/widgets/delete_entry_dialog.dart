
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/Diary.dart';

class DeleteEntryDialog extends StatelessWidget {
  const DeleteEntryDialog({
    Key? key,
    required this.thoughtsCollectionReference,
    required this.diary,
  }) : super(key: key);

  final CollectionReference<Object?> thoughtsCollectionReference;
  final Diary diary;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete Entry',
        style: TextStyle(
            color: Colors.red),
      ),
      content: const Text(
          'Are you sure you want to delete entry?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(
                  context)
                  .pop();
            },
            child: const Text(
                'Cancel')),
        TextButton(
            onPressed: () {
              thoughtsCollectionReference
                  .doc(diary.id)
                  .delete()
                  .then((value) =>
                  Navigator.of(
                      context)
                      .pop());
            },
            child: const Text(
                'Delete'))
      ],
    );
  }
}
