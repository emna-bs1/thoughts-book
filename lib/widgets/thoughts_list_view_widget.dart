import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thoughts/screens/main.dart';
import '../model/Diary.dart';
import '../utils/util.dart';
import 'delete_entry_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;

class ThoughtsListViewWidget extends StatefulWidget {
  const ThoughtsListViewWidget({
    Key? key,
    required this.width, required this.selectedDate,
  }) : super(key: key);

  final DateTime selectedDate;
  final double width;

  @override
  State<ThoughtsListViewWidget> createState() => _ThoughtsListViewWidgetState();
}

class _ThoughtsListViewWidgetState extends State<ThoughtsListViewWidget> {

  Image? _imageDisplay;
  File? _pickedFile;
  TextEditingController? _titleTextController;
  TextEditingController? _descriptionTextController;
  String? _buttonText = 'Done';
  CollectionReference diaryCollectionReference =
  FirebaseFirestore.instance.collection('diaries');

  @override
  Widget build(BuildContext context) {
    CollectionReference thoughtsCollectionReference =
        FirebaseFirestore.instance.collection('diaries');
    return StreamBuilder<QuerySnapshot>(
        stream: thoughtsCollectionReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }
          var filteredList = snapshot.data!.docs.map((diary) {
            return Diary.fromDocument(diary);
          }).where((element) {
            return (element.userId == FirebaseAuth.instance.currentUser!.uid);
          }).toList();

          return Container(
            width: widget.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
              child: Column(
                children: [
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Diary diary = filteredList[index];
                        return SizedBox(
                          width: widget.width * 0.8,
                          child: Card(
                              elevation: 4.0,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            formatDate(
                                                diary.entryTime!.toDate()),
                                            style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextButton.icon(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return DeleteEntryDialog(
                                                        thoughtsCollectionReference:
                                                            thoughtsCollectionReference,
                                                        diary: diary);
                                                  });
                                            },
                                            icon: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.grey),
                                            label: const Text(''),
                                          )
                                        ],
                                      ),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              formatDateFromTimestampHour(
                                                  diary.entryTime),
                                              style: const TextStyle(
                                                  color: Colors.green),
                                            ),
                                            TextButton.icon(
                                              onPressed: () {},
                                              icon:
                                                  const Icon(Icons.more_horiz),
                                              label: Text(''),
                                            ),
                                          ],
                                        ),
                                        Image.network((diary.photosUrls == null)
                                            ? 'https://picsum.photos/400/200'
                                            : diary.photosUrls.toString()),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      diary.title!,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      diary.entry!,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      _descriptionTextController = TextEditingController(text: diary.entry);
                                      _titleTextController = TextEditingController(text: diary.title);
                                      _imageDisplay = Image.network(diary.photosUrls == null ? 'https://picsum.photos/400/200' : diary.photosUrls.toString());
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: widget.width,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            formatDate(diary
                                                                .entryTime!
                                                                .toDate()),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .blueGrey,
                                                                fontSize: 19,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const Spacer(),
                                                          IconButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context){
                                                                    return AlertDialog(
                                                                      elevation: 5,
                                                                      content: SingleChildScrollView(
                                                                        child: Container(
                                                                          width: widget.width,
                                                                          height: MediaQuery.of(context).size.height * 0.8,
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
                                                                                        final _fieldsNotEmpty = _titleTextController
                                                                                            .toString()
                                                                                            .isNotEmpty &&
                                                                                            _descriptionTextController
                                                                                                .toString()
                                                                                                .isNotEmpty;
                                                                                        if (_fieldsNotEmpty) {
                                                                                          diaryCollectionReference.doc(diary.id).update(Diary(
                                                                                            title: _titleTextController!.text,
                                                                                            entry: _descriptionTextController!.text,
                                                                                            entryTime: Timestamp.fromDate(widget.selectedDate),
                                                                                            userId: FirebaseAuth.instance.currentUser!.uid,
                                                                                            author: FirebaseAuth.instance.currentUser!.email!
                                                                                                .split('@')[0],
                                                                                          ).toMap());
                                                                                        }
                                                                                        if (_pickedFile != null) {
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
                                                                                                    .doc(diary.id).update(
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
                                                                                      child: Text(_buttonText!),
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
                                                                                children: [Text(formatDate(widget.selectedDate))],
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
                                                                                            height: MediaQuery.of(context).size.height * 0.7 / 2,
                                                                                            child: _imageDisplay),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(0.8),
                                                                                          child: SizedBox(
                                                                                            height: 50,
                                                                                            width: 250,
                                                                                            child: TextFormField(
                                                                                              controller: _titleTextController,
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

                                                                                              controller: _descriptionTextController,
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
                                                                    // return UpdateEntryDialog()
                                                                  }
                                                                );
                                                              },
                                                              icon: const Icon(
                                                                  Icons.edit)),
                                                          IconButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                showDialog(context: context, builder: (context){
                                                                  return DeleteEntryDialog(thoughtsCollectionReference: thoughtsCollectionReference, diary: diary);
                                                                });
                                                              },
                                                              icon: const Icon(
                                                                  Icons.delete)),
                                                        ],
                                                      ),
                                                    )
                                                  ]),

                                              content: ListTile(subtitle: Column(
                                                children: [Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      formatDateFromTimestampHour(
                                                          diary.entryTime),
                                                      style: const TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                  ],
                                                ),
                                                  SizedBox(
                                                    height: MediaQuery.of(context).size.height * 0.4,
                                                    child: Image.network((diary.photosUrls == null) ? 'https://picsum.photos/200/200' : diary.photosUrls.toString()),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Flexible(child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                            child: Text(
                                                              diary.title!,
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                            child: Text(
                                                              diary.entry!,
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {Navigator.of(context).pop(); },
                                                  child: Text('Cancel'),
                                                )
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                ],
                              )),
                        );
                      }),
                ],
              ),
            ),
          );
        });
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
