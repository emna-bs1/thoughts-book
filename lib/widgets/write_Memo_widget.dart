import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thoughts/utils/util.dart';
import 'package:image_picker/image_picker.dart';
import '../model/Diary.dart';

class WriteMemoryDialog extends StatefulWidget {
  const WriteMemoryDialog({
    Key? key,
    required this.width,
    required this.height,
    required TextEditingController titleTextController,
    required TextEditingController descriptionTextController,
    this.selectedDate,
  })  : _titleTextController = titleTextController,
        _descriptionTextController = descriptionTextController,
        super(key: key);

  final DateTime? selectedDate;
  final double width;
  final double height;
  final TextEditingController _titleTextController;
  final TextEditingController _descriptionTextController;

  @override
  State<WriteMemoryDialog> createState() => _WriteMemoryDialogState();
}

class _WriteMemoryDialogState extends State<WriteMemoryDialog> {
  String _buttonText = 'Done';
  Image? _imageDisplay;
  File? _pickedFile;
  CollectionReference diaryCollectionReference =
      FirebaseFirestore.instance.collection('diaries');
  String? currentId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      content: SingleChildScrollView(
        child: Container(
          width: widget.width,
          height: widget.height * 0.8,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Discard'),
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        firebaseStorage.FirebaseStorage fs =
                            firebaseStorage.FirebaseStorage.instance;

                        final dateTime = DateTime.now();
                        final path = '$dateTime';
                        final _fieldsNotEmpty = widget._titleTextController.text
                                .toString()
                                .isNotEmpty &&
                            widget._descriptionTextController.text
                                .toString()
                                .isNotEmpty;
                        if (_fieldsNotEmpty) {
                          diaryCollectionReference.add(Diary(
                            title: widget._titleTextController.text,
                            entry: widget._descriptionTextController.text,
                            entryTime: Timestamp.fromDate(widget.selectedDate!),
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            author: FirebaseAuth.instance.currentUser!.email!
                                .split('@')[0],
                          ).toMap()).then((value) {
                            setState((){
                              currentId = value.id;
                            });
                          });
                        }
                        if (_pickedFile != null) {
                          String encodedImageString = base64.encode(
                              File(_pickedFile!.path)
                                  .readAsBytesSync()
                                  .toList());
                          firebaseStorage.SettableMetadata? metadata =
                              firebaseStorage.SettableMetadata(
                            contentType: 'image/jpg',
                            customMetadata: {'picked-file-path': path},
                          );
                          // relative path from the reference
                              
                          Future.delayed(const Duration(milliseconds: 1500)).then((value){
                            fs
                                .ref()
                                .child(
                                'images/$path${FirebaseAuth.instance.currentUser!.uid}')
                                .putFile(_pickedFile!, metadata)
                                .then((value) {
                              print(value);
                              value.ref.getDownloadURL().then((value) {
                                return diaryCollectionReference
                                    .doc(currentId).update(
                                    {'photos_urls' : value.toString()}
                                );
                              });
                            });
                          });
                        }
                        setState(() {
                          _buttonText = 'Saving...';
                        });
                        Future.delayed(
                          Duration(milliseconds: 2500),
                        ).then((value) => Navigator.of(context).pop());
                      },
                      child: Text(_buttonText),
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.green,
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              side: BorderSide(color: Colors.green))),
                    ),
                  )
                ],
              ),
              Row(
                children: [Text(formatDate(widget.selectedDate!))],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                          splashRadius: 26,
                          onPressed: () => pickImage(),
                          icon: const Icon(Icons.image_rounded),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    child: Column(
                      children: [
                        SizedBox(
                            height: widget.height * 0.7 / 2,
                            child: _imageDisplay),
                        Padding(
                          padding: const EdgeInsets.all(0.8),
                          child: SizedBox(
                            height: 50,
                            width: 250,
                            child: TextFormField(
                              controller: widget._titleTextController,
                              decoration:
                                  const InputDecoration(hintText: 'Title...'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.8),
                          child: SizedBox(
                            height: 100,
                            width: 250,
                            child: TextFormField(
                              //multiline
                              maxLines: null,
                              controller: widget._descriptionTextController,
                              decoration: const InputDecoration(
                                  hintText: 'Description...'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        _pickedFile = imageTemporary;
        _imageDisplay = Image.file(imageTemporary);
      });
    } catch (error) {
      print("error: $error");
    }
  }
}
